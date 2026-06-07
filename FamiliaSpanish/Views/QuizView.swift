import SwiftUI

struct QuizView: View {
    let lesson: Lesson

    var body: some View {
        List {
            Section {
                Text("Quiz engine is intentionally deferred to the next milestone. This screen exists so milestone 1 has the expected navigation surface.")
                    .foregroundStyle(.secondary)
            }

            Section("Planned Questions") {
                ForEach(lesson.quiz) { question in
                    QuizQuestionPlaceholderRow(question: question)
                }
            }
        }
        .navigationTitle("Quiz")
    }
}

#Preview {
    NavigationStack {
        QuizView(lesson: Curriculum.placeholder.lessons[0])
    }
}
