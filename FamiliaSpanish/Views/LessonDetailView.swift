import SwiftUI

struct LessonDetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    let lesson: Lesson
    let onStartQuiz: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(lesson.title)
                        .font(.largeTitle.bold())
                    Text("\(lesson.level.capitalized) • \(lesson.estimatedMinutes) minutes")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(lesson.context)
                        .textSelection(.enabled)
                }
                .padding(AppTheme.contentPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius)
                        .strokeBorder(AppTheme.edgeGradient(for: colorScheme), lineWidth: 1.2)
                }

                GrammarFocusView(items: lesson.grammarFocus)
                VocabularyView(words: lesson.vocabulary)
                ModelSentencesView(sentences: lesson.modelSentences)

                Button("Start Quiz", systemImage: "play.circle.fill", action: onStartQuiz)
                    .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                .accessibilityHint("Opens the lesson quiz placeholder screen.")
            }
            .padding(AppTheme.contentPadding)
        }
        .background(AuroraBackgroundView())
    }
}

#Preview {
    LessonDetailView(lesson: Curriculum.placeholder.lessons[0], onStartQuiz: {})
}
