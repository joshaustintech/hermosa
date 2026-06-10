import SwiftUI

struct HermosaFlashcardStudyView: View {
    let title: String
    let cards: [HermosaFlashcard]

    var body: some View {
        HermosaScreenScrollView {
            HermosaScreenHeader(title: title)

            if cards.isEmpty {
                HermosaStatusCard(
                    title: "No Cards Yet",
                    message: "This deck will appear once lesson-linked flashcard content is available.",
                    systemImage: "rectangle.stack.badge.minus",
                    imageColor: HermosaColors.accentSecondary
                )
            } else {
                HermosaFlashcardDeckContainer(cards: cards)
            }
        }
        .background(HermosaColors.backgroundBase)
    }
}

private struct HermosaFlashcardDeckContainer: View {
    let cards: [HermosaFlashcard]

    var body: some View {
        HermosaFlashcardDeck(cards: cards)
    }
}

private struct HermosaFlashcardDeck: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var cards: [HermosaFlashcard]
    @State private var faceStates: [String: Bool]
    @GestureState private var dragOffset: CGSize = .zero
    @State private var committedOffset: CGSize = .zero
    @State private var reorderToken = 0

    init(cards: [HermosaFlashcard]) {
        _cards = State(initialValue: cards)
        _faceStates = State(
            initialValue: Dictionary(
                uniqueKeysWithValues: cards.map { ($0.id, false) }
            )
        )
    }

    var body: some View {
        GeometryReader { proxy in
            let deckWidth = proxy.size.width
            let topCard = cards.first
            let visibleCards = Array(cards.prefix(3).enumerated())
            let horizontalThreshold = min(120, deckWidth * 0.24)
            let verticalThreshold: CGFloat = 110

            VStack(alignment: .leading, spacing: HermosaMetrics.space16) {
                ZStack {
                    ForEach(visibleCards.reversed(), id: \.element.id) { entry in
                        let index = entry.offset
                        let card = entry.element

                        HermosaFlashcardFace(
                            card: card,
                            isShowingBack: faceStates[card.id, default: false],
                            isTopCard: index == 0,
                            dragOffset: index == 0 ? combinedDragOffset : .zero,
                            reduceMotion: reduceMotion
                        )
                        .scaleEffect(stackScale(for: index))
                        .offset(
                            x: index == 0 ? 0 : stackHorizontalOffset(for: index),
                            y: stackVerticalOffset(for: index)
                        )
                        .opacity(stackOpacity(for: index))
                        .zIndex(Double(visibleCards.count - index))
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 390)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 12)
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation
                        }
                        .onEnded { value in
                            guard topCard != nil else { return }

                            let translation = value.translation
                            let isHorizontal = abs(translation.width) > abs(translation.height)

                            if isHorizontal, abs(translation.width) > horizontalThreshold {
                                performHorizontalMove(width: translation.width, deckWidth: deckWidth)
                            } else if isHorizontal == false, abs(translation.height) > verticalThreshold {
                                flipTopCard()
                            } else {
                                cancelDrag()
                            }
                        }
                )
                .animation(animation, value: dragOffset)
                .animation(animation, value: reorderToken)
                .animation(animation, value: faceStates)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(minHeight: 520)
    }

    private var animation: Animation {
        reduceMotion ? .easeInOut(duration: 0.18) : .spring(response: 0.34, dampingFraction: 0.82)
    }

    private var combinedDragOffset: CGSize {
        CGSize(
            width: dragOffset.width + committedOffset.width,
            height: dragOffset.height + committedOffset.height
        )
    }

    private func flipTopCard() {
        guard let topCard = cards.first else { return }
        withAnimation(animation) {
            faceStates[topCard.id, default: false].toggle()
        }
    }

    private func cancelDrag() {
        withAnimation(animation) {
            committedOffset = .zero
        }
    }

    private func performHorizontalMove(width: CGFloat, deckWidth: CGFloat) {
        guard cards.count > 1 else {
            cancelDrag()
            return
        }

        let travel = width < 0 ? -(deckWidth + 80) : deckWidth + 80

        withAnimation(animation) {
            committedOffset = CGSize(width: travel, height: width < 0 ? 18 : -18)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) {
            if width < 0 {
                let firstCard = cards.removeFirst()
                cards.append(firstCard)
            } else if let lastCard = cards.popLast() {
                cards.insert(lastCard, at: 0)
            }

            reorderToken += 1
            committedOffset = .zero
        }
    }

    private func stackScale(for index: Int) -> CGFloat {
        switch index {
        case 0: 1
        case 1: 0.97
        default: 0.94
        }
    }

    private func stackVerticalOffset(for index: Int) -> CGFloat {
        CGFloat(index) * 18
    }

    private func stackHorizontalOffset(for index: Int) -> CGFloat {
        CGFloat(index) * 4
    }

    private func stackOpacity(for index: Int) -> Double {
        switch index {
        case 0: 1
        case 1: 0.96
        default: 0.9
        }
    }
}

private struct HermosaFlashcardFace: View {
    let card: HermosaFlashcard
    let isShowingBack: Bool
    let isTopCard: Bool
    let dragOffset: CGSize
    let reduceMotion: Bool

    var body: some View {
        ZStack {
            side(isBack: false)
                .opacity(frontOpacity)

            side(isBack: true)
                .opacity(backOpacity)
                .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
        }
        .rotation3DEffect(.degrees(rotationDegrees), axis: (x: 1, y: 0, z: 0))
        .offset(dragOffset)
        .shadow(
            color: HermosaColors.shadowLight.opacity(isTopCard ? 0.5 : 0.18),
            radius: isTopCard ? 18 : 10,
            x: 0,
            y: isTopCard ? 10 : 4
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }

    private var frontOpacity: Double {
        displayedFace == .front ? 1 : 0
    }

    private var backOpacity: Double {
        displayedFace == .back ? 1 : 0
    }

    private var displayedFace: DisplayedFace {
        let normalized = rotationDegrees.truncatingRemainder(dividingBy: 360)
        let positive = normalized >= 0 ? normalized : normalized + 360
        return positive < 90 || positive > 270 ? .front : .back
    }

    private var rotationDegrees: Double {
        let base = isShowingBack ? 180.0 : 0.0
        guard isTopCard else { return base }

        if reduceMotion {
            return base
        }

        let dragRotation = Double(dragOffset.height / 2.6)
        return max(min(base - dragRotation, 220), -220)
    }

    private var accessibilityLabel: String {
        let visibleText = isShowingBack ? card.backText : card.frontText
        return "\(card.kind.rawValue), \(card.lessonTitle), \(visibleText)"
    }

    @ViewBuilder
    private func side(isBack: Bool) -> some View {
        VStack(alignment: .leading, spacing: HermosaMetrics.space16) {
            HStack(alignment: .top, spacing: HermosaMetrics.space12) {
                VStack(alignment: .leading, spacing: HermosaMetrics.space8) {
                    Text(isBack ? "Back" : "Front")
                        .hermosaTextStyle(.metadata)
                        .foregroundStyle(HermosaColors.accentPrimary)

                    Text(card.kind.rawValue)
                        .hermosaTextStyle(.secondaryBody)
                        .foregroundStyle(HermosaColors.textSecondary)
                }

                Spacer(minLength: HermosaMetrics.space12)
            }

            VStack(alignment: .leading, spacing: HermosaMetrics.space12) {
                Text(isBack ? card.backText : card.frontText)
                    .hermosaTextStyle(.display)
                    .foregroundStyle(HermosaColors.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
                    .textSelection(.enabled)

                if let detail = isBack ? card.backDetail : card.frontDetail, detail.isEmpty == false {
                    Text(detail)
                        .hermosaTextStyle(.body)
                        .foregroundStyle(HermosaColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .textSelection(.enabled)
                }
            }

            Spacer(minLength: HermosaMetrics.space12)

            HStack(alignment: .bottom, spacing: HermosaMetrics.space12) {
                VStack(alignment: .leading, spacing: HermosaMetrics.space4) {
                    Text("Lesson")
                        .hermosaTextStyle(.metadata)
                        .foregroundStyle(HermosaColors.textTertiary)

                    Text(card.lessonTitle)
                        .hermosaTextStyle(.bodyEmphasized)
                        .foregroundStyle(HermosaColors.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 340, alignment: .topLeading)
        .padding(HermosaMetrics.space24)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(isBack ? HermosaColors.surfaceStatic : HermosaColors.surfaceFeature)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(
                    isTopCard ? HermosaColors.strokeInteractive.opacity(0.9) : HermosaColors.strokeSoft,
                    lineWidth: HermosaMetrics.standardBorderWidth
                )
        }
    }

    private enum DisplayedFace {
        case front
        case back
    }
}
