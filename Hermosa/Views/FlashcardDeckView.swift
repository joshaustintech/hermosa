import SwiftUI

struct HermosaFlashcardStudyView: View {
    let title: String
    let cards: [HermosaFlashcard]
    var onComplete: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        HermosaScreenScrollView(isScrollDisabled: true) {
            HermosaScreenHeader(title: title)

            if cards.isEmpty {
                HermosaStatusCard(
                    title: "No Cards Yet",
                    message: "This deck will appear once lesson-linked flashcard content is available.",
                    systemImage: "rectangle.stack.badge.minus",
                    imageColor: HermosaColors.accentSecondary
                )
            } else {
                HermosaFlashcardDeck(cards: cards)

                if let onComplete {
                    Button(action: {
                        onComplete()
                        dismiss()
                    }) {
                        Label("Finish Review", systemImage: "checkmark.circle.fill")
                    }
                    .buttonStyle(HermosaPrimaryButtonStyle())
                    .padding(.top, HermosaMetrics.space16)
                    .accessibilityHint("Saves your review progress and returns to the previous screen.")
                }
            }
        }
        .background(HermosaColors.backgroundBase)
    }
}

private struct HermosaFlashcardDeck: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var cards: [HermosaFlashcard]
    @State private var faceAngles: [String: Double]
    @State private var dragTranslation: CGSize = .zero
    @State private var transitionProgress: CGFloat = .zero
    @State private var transition: DeckTransition = .idle

    init(cards: [HermosaFlashcard]) {
        _cards = State(initialValue: cards)
        _faceAngles = State(
            initialValue: Dictionary(
                uniqueKeysWithValues: cards.map { ($0.id, 0) }
            )
        )
    }

    var body: some View {
        GeometryReader { proxy in
            let deckWidth = proxy.size.width
            let horizontalThreshold = min(120, deckWidth * 0.24)
            let verticalThreshold: CGFloat = 110
            let interaction = currentInteraction(
                deckWidth: deckWidth,
                horizontalThreshold: horizontalThreshold,
                verticalThreshold: verticalThreshold
            )
            let movingBottomCardID = movingBottomCardID(for: interaction)
            let visibleCards = Array(cards.filter { $0.id != movingBottomCardID }.prefix(3))

            VStack(alignment: .leading, spacing: HermosaMetrics.space16) {
                ZStack {
                    ForEach(visibleCards.reversed(), id: \.id) { card in
                        let pose = pose(for: card, interaction: interaction)

                        HermosaFlashcardFace(
                            card: card,
                            rotationAngle: rotationAngle(for: card, interaction: interaction),
                            zRotation: pose.zRotation,
                            isHighlighted: pose.isHighlighted,
                            offset: CGSize(width: pose.x, height: pose.y),
                            reduceMotion: reduceMotion
                        )
                        .scaleEffect(pose.scale)
                        .zIndex(pose.zIndex)
                    }

                    if let movingBottomCard = movingBottomCard(for: interaction) {
                        let pose = movingBottomPose(for: movingBottomCard, interaction: interaction)

                        HermosaFlashcardFace(
                            card: movingBottomCard,
                            rotationAngle: faceAngles[movingBottomCard.id, default: 0],
                            zRotation: pose.zRotation,
                            isHighlighted: true,
                            offset: CGSize(width: pose.x, height: pose.y),
                            reduceMotion: reduceMotion
                        )
                        .scaleEffect(pose.scale)
                        .zIndex(pose.zIndex)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 390)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 12)
                        .onChanged { value in
                            guard transition == .idle else { return }
                            dragTranslation = value.translation
                        }
                        .onEnded { _ in
                            handleGestureEnd(
                                deckWidth: deckWidth,
                                horizontalThreshold: horizontalThreshold,
                                verticalThreshold: verticalThreshold
                            )
                        }
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(minHeight: 520)
    }

    private var movementAnimation: Animation {
        reduceMotion ? .easeInOut(duration: 0.2) : .spring(response: 0.38, dampingFraction: 0.84)
    }

    private var flipAnimation: Animation {
        reduceMotion ? .easeInOut(duration: 0.16) : .easeInOut(duration: 0.32)
    }

    private func currentInteraction(
        deckWidth: CGFloat,
        horizontalThreshold: CGFloat,
        verticalThreshold: CGFloat
    ) -> DeckInteraction {
        switch transition {
        case let .cyclingTopToBack(cardID):
            return .left(cardID: cardID, progress: transitionProgress, isCommitted: true)
        case let .surfacingBottomToTop(cardID):
            return .right(cardID: cardID, progress: transitionProgress, isCommitted: true)
        case .flipping:
            return .idle
        case .idle:
            guard transition == .idle else { return .idle }

            let translation = dragTranslation
            guard abs(translation.width) > 8 || abs(translation.height) > 8 else {
                return .idle
            }

            if abs(translation.width) > abs(translation.height) {
                let progress = min(abs(translation.width) / horizontalThreshold, 1)

                if translation.width < 0 {
                    guard let topCard = cards.first else { return .idle }
                    return .left(cardID: topCard.id, progress: progress, isCommitted: false)
                } else {
                    guard cards.count > 1, let bottomCard = cards.last else { return .idle }
                    return .right(cardID: bottomCard.id, progress: progress, isCommitted: false)
                }
            } else {
                let progress = min(abs(translation.height) / verticalThreshold, 1)
                let direction: VerticalDirection = translation.height < 0 ? .up : .down
                return .vertical(direction: direction, progress: progress)
            }
        }
    }

    private func handleGestureEnd(
        deckWidth: CGFloat,
        horizontalThreshold: CGFloat,
        verticalThreshold: CGFloat
    ) {
        guard transition == .idle else { return }

        let translation = dragTranslation
        let isHorizontal = abs(translation.width) > abs(translation.height)

        if isHorizontal, abs(translation.width) > horizontalThreshold {
            if translation.width < 0 {
                commitLeftSwipe(startingProgress: min(abs(translation.width) / horizontalThreshold, 1))
            } else {
                commitRightSwipe(startingProgress: min(abs(translation.width) / horizontalThreshold, 1))
            }
        } else if isHorizontal == false, abs(translation.height) > verticalThreshold {
            let direction: VerticalDirection = translation.height < 0 ? .up : .down
            let progress = min(abs(translation.height) / verticalThreshold, 1)
            commitFlip(direction: direction, startingProgress: progress)
        } else {
            withAnimation(movementAnimation) {
                dragTranslation = .zero
            }
        }
    }

    private func commitFlip(direction: VerticalDirection, startingProgress: CGFloat) {
        guard let topCard = cards.first else { return }

        let delta = direction == .up ? -180.0 : 180.0
        let partialAngle = flipPreviewAngle(direction: direction, progress: startingProgress)
        transition = .flipping(cardID: topCard.id)

        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            faceAngles[topCard.id, default: 0] += partialAngle
            dragTranslation = .zero
        }

        withAnimation(flipAnimation) {
            faceAngles[topCard.id, default: 0] += delta - partialAngle
        } completion: {
            transition = .idle
        }
    }

    private func commitLeftSwipe(startingProgress: CGFloat) {
        guard cards.count > 1, let topCard = cards.first else {
            withAnimation(movementAnimation) {
                dragTranslation = .zero
            }
            return
        }

        transition = .cyclingTopToBack(cardID: topCard.id)
        transitionProgress = min(startingProgress * 0.55, 0.55)
        dragTranslation = .zero

        withAnimation(movementAnimation) {
            transitionProgress = 1
        } completion: {
            let firstCard = cards.removeFirst()
            cards.append(firstCard)
            finishHorizontalTransition()
        }
    }

    private func commitRightSwipe(startingProgress: CGFloat) {
        guard cards.count > 1, let bottomCard = cards.last else {
            withAnimation(movementAnimation) {
                dragTranslation = .zero
            }
            return
        }

        transition = .surfacingBottomToTop(cardID: bottomCard.id)
        transitionProgress = min(startingProgress * 0.55, 0.55)
        dragTranslation = .zero

        withAnimation(movementAnimation) {
            transitionProgress = 1
        } completion: {
            if let lastCard = cards.popLast() {
                cards.insert(lastCard, at: 0)
            }
            finishHorizontalTransition()
        }
    }

    private func finishHorizontalTransition() {
        transition = .idle
        transitionProgress = .zero
        dragTranslation = .zero
    }

    private func movingBottomCardID(for interaction: DeckInteraction) -> String? {
        if case let .right(cardID, _, _) = interaction {
            return cardID
        }

        return nil
    }

    private func movingBottomCard(for interaction: DeckInteraction) -> HermosaFlashcard? {
        guard let cardID = movingBottomCardID(for: interaction) else { return nil }
        return cards.first { $0.id == cardID }
    }

    private func pose(for card: HermosaFlashcard, interaction: DeckInteraction) -> CardPose {
        guard let actualIndex = cards.firstIndex(where: { $0.id == card.id }) else {
            return slotPose(for: 2)
        }

        switch interaction {
        case let .left(cardID, progress, isCommitted):
            if card.id == cardID {
                return isCommitted
                    ? leftCyclePose(progress: progress)
                    : leftDragPose(progress: progress)
            }

            let fromSlot = min(actualIndex, 2)
            let toSlot = max(fromSlot - 1, 0)
            return interpolate(slotPose(for: fromSlot), slotPose(for: toSlot), progress: progress)

        case .right:
            return slotPose(for: min(actualIndex, 2))

        case .vertical, .idle:
            return slotPose(for: min(actualIndex, 2))
        }
    }

    private func movingBottomPose(for card: HermosaFlashcard, interaction: DeckInteraction) -> CardPose {
        guard case let .right(_, progress, isCommitted) = interaction else {
            return slotPose(for: 2)
        }

        let start = slotPose(for: min(max(cards.count - 1, 1), 2))
        let dragProgress = isCommitted ? progress : min(progress * 0.55, 0.55)

        return rightSurfacePose(from: start, progress: dragProgress, isCommitted: isCommitted)
    }

    private func rotationAngle(for card: HermosaFlashcard, interaction: DeckInteraction) -> Double {
        let baseAngle = faceAngles[card.id, default: 0]

        guard card.id == cards.first?.id else {
            return baseAngle
        }

        guard reduceMotion == false else {
            return baseAngle
        }

        if case let .vertical(direction, progress) = interaction {
            return baseAngle + flipPreviewAngle(direction: direction, progress: progress)
        }

        return baseAngle
    }

    private func flipPreviewAngle(direction: VerticalDirection, progress: CGFloat) -> Double {
        let clamped = min(max(progress, 0), 1)
        let angle = Double(clamped) * 132
        return direction == .up ? -angle : angle
    }

    private func slotPose(for slot: Int) -> CardPose {
        switch slot {
        case 0:
            CardPose(x: 0, y: 0, scale: 1, zRotation: 0, zIndex: 20, isHighlighted: true)
        case 1:
            CardPose(x: 4, y: 18, scale: 0.97, zRotation: 0, zIndex: 12, isHighlighted: false)
        default:
            CardPose(x: 8, y: 36, scale: 0.94, zRotation: 0, zIndex: 8, isHighlighted: false)
        }
    }

    private func interpolate(
        _ from: CardPose,
        _ to: CardPose,
        progress: CGFloat,
        zIndex: Double? = nil,
        highlighted: Bool? = nil
    ) -> CardPose {
        let clamped = min(max(progress, 0), 1)

        return CardPose(
            x: from.x + ((to.x - from.x) * clamped),
            y: from.y + ((to.y - from.y) * clamped),
            scale: from.scale + ((to.scale - from.scale) * clamped),
            zRotation: from.zRotation + ((to.zRotation - from.zRotation) * clamped),
            zIndex: zIndex ?? (from.zIndex + ((to.zIndex - from.zIndex) * Double(clamped))),
            isHighlighted: highlighted ?? (clamped > 0.65 ? to.isHighlighted : from.isHighlighted)
        )
    }

    private func leftDragPose(progress: CGFloat) -> CardPose {
        let clamped = min(max(progress * 0.55, 0), 0.55)
        return interpolate(
            slotPose(for: 0),
            CardPose(x: -142, y: 34, scale: 0.97, zRotation: -10, zIndex: 30, isHighlighted: true),
            progress: clamped / 0.55,
            zIndex: 30,
            highlighted: true
        )
    }

    private func leftCyclePose(progress: CGFloat) -> CardPose {
        let clamped = min(max(progress, 0), 1)
        let pullOut = CardPose(x: -168, y: 42, scale: 0.96, zRotation: -12, zIndex: 30, isHighlighted: true)
        let tuckedBack = CardPose(x: 8, y: 36, scale: 0.94, zRotation: 0, zIndex: 6, isHighlighted: false)

        if clamped < 0.62 {
            return interpolate(slotPose(for: 0), pullOut, progress: clamped / 0.62, zIndex: 30, highlighted: true)
        }

        return interpolate(pullOut, tuckedBack, progress: (clamped - 0.62) / 0.38)
    }

    private func rightSurfacePose(from start: CardPose, progress: CGFloat, isCommitted: Bool) -> CardPose {
        let clamped = min(max(progress, 0), 1)
        let pulledOut = CardPose(x: 132, y: -10, scale: 0.98, zRotation: 10, zIndex: 24, isHighlighted: true)
        let top = slotPose(for: 0)

        if clamped < 0.55 {
            let pose = interpolate(start, pulledOut, progress: clamped / 0.55)
            return CardPose(
                x: pose.x,
                y: pose.y,
                scale: pose.scale,
                zRotation: pose.zRotation,
                zIndex: isCommitted && clamped >= 0.18 ? 34 : start.zIndex,
                isHighlighted: isCommitted && clamped >= 0.18
            )
        }

        return interpolate(pulledOut, top, progress: (clamped - 0.55) / 0.45, zIndex: 40, highlighted: true)
    }
}

private struct HermosaFlashcardFace: View {
    let card: HermosaFlashcard
    let rotationAngle: Double
    let zRotation: Double
    let isHighlighted: Bool
    let offset: CGSize
    let reduceMotion: Bool

    var body: some View {
        ZStack {
            side(isBack: false)
                .opacity(displayedFace == .front ? 1 : 0)
                .transaction { transaction in
                    transaction.animation = nil
                }

            side(isBack: true)
                .opacity(displayedFace == .back ? 1 : 0)
                .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                .transaction { transaction in
                    transaction.animation = nil
                }
        }
        .rotation3DEffect(.degrees(rotationAngle), axis: (x: 1, y: 0, z: 0))
        .rotationEffect(.degrees(reduceMotion ? 0 : zRotation))
        .offset(offset)
        .shadow(
            color: HermosaColors.shadowLight.opacity(isHighlighted ? 0.5 : 0.18),
            radius: isHighlighted ? 18 : 10,
            x: 0,
            y: isHighlighted ? 10 : 4
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }

    private var displayedFace: DisplayedFace {
        let normalized = rotationAngle.truncatingRemainder(dividingBy: 360)
        let positive = normalized >= 0 ? normalized : normalized + 360
        return positive < 90 || positive > 270 ? .front : .back
    }

    private var accessibilityLabel: String {
        let visibleText = displayedFace == .back ? card.backText : card.frontText
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
                let primaryText = isBack ? card.backText : card.frontText

                Text(primaryText)
                    .font(cardTextFont(for: primaryText))
                    .foregroundStyle(HermosaColors.textPrimary)
                    .lineLimit(cardTextLineLimit(for: primaryText))
                    .minimumScaleFactor(0.68)
                    .allowsTightening(true)
                    .textSelection(.enabled)

                if let detail = isBack ? card.backDetail : card.frontDetail, detail.isEmpty == false {
                    Text(detail)
                        .hermosaTextStyle(.body)
                        .foregroundStyle(HermosaColors.textSecondary)
                        .lineLimit(3)
                        .minimumScaleFactor(0.8)
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
                        .lineLimit(2)
                        .minimumScaleFactor(0.82)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 340, alignment: .topLeading)
        .padding(HermosaMetrics.space24)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(isBack ? HermosaColors.surfaceStatic : HermosaColors.surfaceFeature)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(
                    isHighlighted ? HermosaColors.strokeInteractive.opacity(0.9) : HermosaColors.strokeSoft,
                    lineWidth: HermosaMetrics.standardBorderWidth
                )
        }
    }

    private func cardTextFont(for text: String) -> Font {
        switch text.count {
        case 0...42:
            .system(size: 34, weight: .semibold, design: .serif)
        case 43...76:
            .system(size: 30, weight: .semibold, design: .serif)
        case 77...115:
            .system(size: 26, weight: .semibold, design: .serif)
        default:
            .system(size: 23, weight: .semibold, design: .serif)
        }
    }

    private func cardTextLineLimit(for text: String) -> Int {
        text.count > 115 ? 6 : 5
    }

    private enum DisplayedFace {
        case front
        case back
    }
}

private struct CardPose {
    var x: CGFloat
    var y: CGFloat
    var scale: CGFloat
    var zRotation: Double
    var zIndex: Double
    var isHighlighted: Bool
}

private enum DeckTransition: Equatable {
    case idle
    case flipping(cardID: String)
    case cyclingTopToBack(cardID: String)
    case surfacingBottomToTop(cardID: String)
}

private enum DeckInteraction: Equatable {
    case idle
    case vertical(direction: VerticalDirection, progress: CGFloat)
    case left(cardID: String, progress: CGFloat, isCommitted: Bool)
    case right(cardID: String, progress: CGFloat, isCommitted: Bool)
}

private enum VerticalDirection: Equatable {
    case up
    case down
}

#Preview("Flashcard Deck") {
    HermosaFlashcardStudyView(
        title: "Vocabulary Flashcards",
        cards: Curriculum.placeholder.lessons[0].vocabularyFlashcards
    )
}

#Preview("Empty Flashcard Deck") {
    HermosaFlashcardStudyView(
        title: "Vocabulary Flashcards",
        cards: []
    )
}
