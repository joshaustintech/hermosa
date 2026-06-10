import SwiftUI

struct LessonDetailView: View {
    let lesson: Lesson
    let onStartQuiz: () -> Void

    var body: some View {
        HermosaScreenScrollView {
            HermosaScreenHeader(
                title: lesson.title,
                subtitle: lesson.context
            )

            HermosaStaticInfoCard {
                VStack(alignment: .leading, spacing: HermosaMetrics.space8) {
                    Text("\(lesson.level.capitalized) • \(lesson.estimatedMinutes) minutes")
                        .hermosaTextStyle(.secondaryBody)
                        .foregroundStyle(HermosaColors.textSecondary)

                    Text(lesson.title)
                        .hermosaTextStyle(.cardTitle)
                        .foregroundStyle(HermosaColors.textPrimary)

                    Text(lesson.context)
                        .hermosaTextStyle(.body)
                        .foregroundStyle(HermosaColors.textSecondary)
                        .textSelection(.enabled)
                }
            }

            GrammarFocusView(items: lesson.grammarFocus)
            VocabularyView(words: lesson.vocabulary)
            ModelSentencesView(sentences: lesson.modelSentences)

            Button("Start Quiz", systemImage: "play.circle.fill", action: onStartQuiz)
                .buttonStyle(HermosaPrimaryButtonStyle())
                .accessibilityHint("Opens the lesson quiz.")
        }
        .background(HermosaColors.backgroundBase)
    }
}

struct LessonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonDetailView(lesson: Curriculum.placeholder.lessons[0], onStartQuiz: {})
    }
}
