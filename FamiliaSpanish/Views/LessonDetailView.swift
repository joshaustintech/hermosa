import SwiftUI

struct LessonDetailView: View {
    let lesson: Lesson
    let onStartQuiz: () -> Void

    var body: some View {
        FamiliaScreenScrollView {
            FamiliaScreenHeader(
                title: lesson.title,
                subtitle: lesson.context
            )

            FamiliaStaticInfoCard {
                VStack(alignment: .leading, spacing: FamiliaMetrics.space8) {
                    Text("\(lesson.level.capitalized) • \(lesson.estimatedMinutes) minutes")
                        .familiaTextStyle(.secondaryBody)
                        .foregroundStyle(FamiliaColors.textSecondary)

                    Text(lesson.title)
                        .familiaTextStyle(.cardTitle)
                        .foregroundStyle(FamiliaColors.textPrimary)

                    Text(lesson.context)
                        .familiaTextStyle(.body)
                        .foregroundStyle(FamiliaColors.textSecondary)
                        .textSelection(.enabled)
                }
            }

            GrammarFocusView(items: lesson.grammarFocus)
            VocabularyView(words: lesson.vocabulary)
            ModelSentencesView(sentences: lesson.modelSentences)

            Button("Start Quiz", systemImage: "play.circle.fill", action: onStartQuiz)
                .buttonStyle(FamiliaPrimaryButtonStyle())
                .accessibilityHint("Opens the lesson quiz placeholder screen.")
        }
        .background(FamiliaColors.backgroundBase)
    }
}

#Preview { LessonDetailView(lesson: Curriculum.placeholder.lessons[0], onStartQuiz: {}) }
