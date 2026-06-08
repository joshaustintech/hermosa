import SwiftUI

struct QuizView: View {
    let lesson: Lesson

    var body: some View {
        FamiliaScreenScrollView {
            FamiliaScreenHeader(
                title: "Quiz",
                subtitle: "This milestone still uses a placeholder quiz surface, but the interaction model now matches the design system."
            )

            FamiliaStaticInfoCard(title: "Status") {
                Text("Quiz engine is intentionally deferred to the next milestone. This screen exists so the current app has the expected navigation surface.")
                    .familiaTextStyle(.body)
                    .foregroundStyle(FamiliaColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            FamiliaScreenSection(
                title: "Planned Questions",
                subtitle: "Answer rows now read as clearly selectable controls."
            ) {
                FamiliaStackedCardGroup {
                ForEach(lesson.quiz) { question in
                    QuizQuestionPlaceholderRow(question: question)
                }
            }
        }
        }
        .background(FamiliaColors.backgroundBase)
    }
}

#Preview {
    NavigationStack {
        QuizView(lesson: Curriculum.placeholder.lessons[0])
    }
}
