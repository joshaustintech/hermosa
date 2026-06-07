import SwiftUI

struct ProgressViewScreen: View {
    let curriculum: Curriculum
    let lessonProgress: [LessonProgress]

    var body: some View {
        List {
            Section("Overview") {
                LabeledContent("Lessons", value: "\(curriculum.lessons.count)")
                LabeledContent("Completed", value: "\(lessonProgress.filter(\.isCompleted).count)")
                LabeledContent("Status", value: "Placeholder")
            }

            Section {
                Text("The full dashboard arrives in a later milestone after quizzes and persisted progress are connected.")
                    .foregroundStyle(.secondary)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.clear)
    }
}

#Preview {
    NavigationStack {
        ProgressViewScreen(curriculum: .placeholder, lessonProgress: [])
    }
}
