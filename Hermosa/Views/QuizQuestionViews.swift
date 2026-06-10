import SwiftUI

struct QuizQuestionCard: View {
    let question: PresentedQuizQuestion
    let selection: Set<UUID>
    let onToggleOption: (UUID) -> Void

    var body: some View {
        HermosaScreenSection(
            title: question.kind.title,
            subtitle: question.kind.subtitle
        ) {
            VStack(alignment: .leading, spacing: HermosaMetrics.space16) {
                Text(question.prompt)
                    .hermosaTextStyle(.cardTitle)
                    .foregroundStyle(HermosaColors.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)

                HermosaStackedCardGroup {
                    ForEach(question.options) { option in
                        HermosaQuizOptionRow(
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
        HermosaStaticInfoCard {
            VStack(alignment: .leading, spacing: HermosaMetrics.space12) {
                Text(item.prompt)
                    .hermosaTextStyle(.cardTitle)
                    .foregroundStyle(HermosaColors.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)

                Text(item.statusText)
                    .hermosaTextStyle(.secondaryBody)
                    .foregroundStyle(item.wasCorrect ? HermosaColors.success : HermosaColors.error)

                Text("Correct answer: \(item.correctAnswerText)")
                    .hermosaTextStyle(.body)
                    .foregroundStyle(HermosaColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                if let selectedAnswerText = item.selectedAnswerText {
                    Text("Your answer: \(selectedAnswerText)")
                        .hermosaTextStyle(.secondaryBody)
                        .foregroundStyle(HermosaColors.textTertiary)
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
        HermosaStaticInfoCard {
            VStack(alignment: .center, spacing: HermosaMetrics.space16) {
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

                VStack(alignment: .center, spacing: HermosaMetrics.space8) {
                    Text(title)
                        .hermosaTextStyle(.sectionTitle)
                        .foregroundStyle(HermosaColors.textPrimary)
                        .multilineTextAlignment(.center)

                    Text(message)
                        .hermosaTextStyle(.body)
                        .foregroundStyle(HermosaColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }

                VStack(alignment: .leading, spacing: HermosaMetrics.space8) {
                    Text(outcome.prompt)
                        .hermosaTextStyle(.bodyEmphasized)
                        .foregroundStyle(HermosaColors.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    if outcome.wasCorrect {
                        Text("Answer: \(outcome.correctAnswerText)")
                            .hermosaTextStyle(.secondaryBody)
                            .foregroundStyle(HermosaColors.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    } else {
                        if let selectedAnswerText = outcome.selectedAnswerText {
                            Text("Your answer: \(selectedAnswerText)")
                                .hermosaTextStyle(.secondaryBody)
                                .foregroundStyle(HermosaColors.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Text("Correct answer: \(outcome.correctAnswerText)")
                            .hermosaTextStyle(.secondaryBody)
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

#Preview("Quiz Question Card") {
    let options = [
        PresentedQuizOption(title: "Nice to meet you"),
        PresentedQuizOption(title: "Good night"),
        PresentedQuizOption(title: "Please"),
        PresentedQuizOption(title: "Thank you")
    ]
    let selectedID = options[0].id
    let question = PresentedQuizQuestion(
        prompt: "What does \"mucho gusto\" mean?",
        kind: .multipleChoice,
        options: options,
        correctOptionIDs: [selectedID]
    )

    return HermosaScreenScrollView {
        QuizQuestionCard(
            question: question,
            selection: [selectedID],
            onToggleOption: { _ in }
        )
    }
}

#Preview("Quiz Review Card") {
    HermosaScreenScrollView {
        QuizReviewCard(
            item: QuizReviewItem(
                prompt: "What does \"mucho gusto\" mean?",
                wasCorrect: false,
                correctAnswerText: "Nice to meet you",
                selectedAnswerText: "Thank you"
            )
        )
    }
}

#Preview("Quiz Feedback Card") {
    HermosaScreenScrollView {
        QuizAnswerFeedbackCard(
            title: "Not Quite",
            message: "Review the highlighted answer, then continue.",
            systemImage: "xmark.circle.fill",
            imageColor: HermosaColors.error,
            outcome: QuizOutcomeSnapshot(
                prompt: "What does \"mucho gusto\" mean?",
                wasCorrect: false,
                correctAnswerText: "Nice to meet you",
                selectedAnswerText: "Thank you"
            )
        )
    }
}
