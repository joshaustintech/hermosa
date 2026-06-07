import SwiftUI

struct LessonDetailView: View {
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

                GrammarFocusView(items: lesson.grammarFocus)
                VocabularyView(words: lesson.vocabulary)
                ModelSentencesView(sentences: lesson.modelSentences)

                Button {
                    onStartQuiz()
                } label: {
                    Label("Start Quiz", systemImage: "play.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .accessibilityHint("Opens the lesson quiz placeholder screen.")
            }
            .padding()
        }
    }
}

#Preview {
    LessonDetailView(lesson: Curriculum.placeholder.lessons[0], onStartQuiz: {})
}
