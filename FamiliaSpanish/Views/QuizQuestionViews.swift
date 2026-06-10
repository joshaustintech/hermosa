import SwiftUI

struct QuizQuestionCard: View {
    let question: PresentedQuizQuestion
    let selection: Set<UUID>
    let onToggleOption: (UUID) -> Void

    var body: some View {
        FamiliaScreenSection(
            title: question.kind.title,
            subtitle: question.kind.subtitle
        ) {
            VStack(alignment: .leading, spacing: FamiliaMetrics.space16) {
                Text(question.prompt)
                    .familiaTextStyle(.cardTitle)
                    .foregroundStyle(FamiliaColors.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)

                FamiliaStackedCardGroup {
                    ForEach(question.options) { option in
                        FamiliaQuizOptionRow(
                            title: option.title,
                            state: selection.contains(option.id) ? .selected : .idle,
                            action: {
                                onToggleOption(option.id)
                            }
                        )
                        .accessibilityLabel(option.title)
                        .accessibilityHint(accessibilityHint)
                    }
                }
            }
        }
    }

    private var accessibilityHint: String {
        switch question.kind {
        case .multipleChoice:
            "Select one answer choice."
        case .multipleSelect:
            "Select all answer choices that apply."
        }
    }

}

struct QuizReviewCard: View {
    let item: QuizReviewItem

    var body: some View {
        FamiliaStaticInfoCard {
            VStack(alignment: .leading, spacing: FamiliaMetrics.space12) {
                Text(item.prompt)
                    .familiaTextStyle(.cardTitle)
                    .foregroundStyle(FamiliaColors.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)

                Text(item.statusText)
                    .familiaTextStyle(.secondaryBody)
                    .foregroundStyle(item.wasCorrect ? FamiliaColors.success : FamiliaColors.error)

                Text("Correct answer: \(item.correctAnswerText)")
                    .familiaTextStyle(.body)
                    .foregroundStyle(FamiliaColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                if let selectedAnswerText = item.selectedAnswerText {
                    Text("Your answer: \(selectedAnswerText)")
                        .familiaTextStyle(.secondaryBody)
                        .foregroundStyle(FamiliaColors.textTertiary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}

struct QuizAnswerFeedbackCard: View {
    let title: String
    let message: String
    let systemImage: String
    let imageColor: Color
    let outcome: QuizOutcomeSnapshot

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showsIcon = false

    var body: some View {
        FamiliaStaticInfoCard {
            VStack(alignment: .center, spacing: FamiliaMetrics.space16) {
                Image(systemName: systemImage)
                    .font(.system(size: 42, weight: .semibold))
                    .foregroundStyle(imageColor)
                    .scaleEffect(showsIcon ? 1 : 0.62)
                    .opacity(showsIcon ? 1 : 0)
                    .rotationEffect(.degrees(reduceMotion ? 0 : (showsIcon ? 0 : -10)))
                    .animation(
                        reduceMotion ? .linear(duration: 0.01) : .spring(response: 0.38, dampingFraction: 0.62),
                        value: showsIcon
                    )
                    .accessibilityHidden(true)

                VStack(alignment: .center, spacing: FamiliaMetrics.space8) {
                    Text(title)
                        .familiaTextStyle(.sectionTitle)
                        .foregroundStyle(FamiliaColors.textPrimary)
                        .multilineTextAlignment(.center)

                    Text(message)
                        .familiaTextStyle(.body)
                        .foregroundStyle(FamiliaColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }

                VStack(alignment: .leading, spacing: FamiliaMetrics.space8) {
                    Text(outcome.prompt)
                        .familiaTextStyle(.bodyEmphasized)
                        .foregroundStyle(FamiliaColors.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    if outcome.wasCorrect {
                        Text("Answer: \(outcome.correctAnswerText)")
                            .familiaTextStyle(.secondaryBody)
                            .foregroundStyle(FamiliaColors.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    } else {
                        if let selectedAnswerText = outcome.selectedAnswerText {
                            Text("Your answer: \(selectedAnswerText)")
                                .familiaTextStyle(.secondaryBody)
                                .foregroundStyle(FamiliaColors.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Text("Correct answer: \(outcome.correctAnswerText)")
                            .familiaTextStyle(.secondaryBody)
                            .foregroundStyle(imageColor)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            showsIcon = false
            withAnimation {
                showsIcon = true
            }
        }
    }
}
