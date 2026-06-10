import SwiftUI

struct ProgressViewScreen: View {
    let curriculum: Curriculum
    let lessonProgress: [LessonProgress]

    var body: some View {
        HermosaScreenScrollView {
            HermosaScreenHeader(
                title: "Progress",
                subtitle: "Track completed lessons and stay oriented as quiz persistence expands."
            )

            HermosaProgressSummaryCard(
                title: "Completed Lessons",
                value: "\(completedCount)",
                detail: "\(curriculum.lessons.count) total lessons in the bundled curriculum.",
                progress: completionRate,
                tone: completedCount == 0 ? .neutral : .success
            )

            HermosaProgressSummaryCard(
                title: "Best Scores Saved",
                value: "\(lessonsWithScores)",
                detail: "Lessons with at least one saved score in local progress data.",
                progress: scoreRate,
                tone: lessonsWithScores == 0 ? .neutral : .progress
            )

            HermosaScreenSection(
                title: "Current Status",
                subtitle: "The full dashboard arrives after quizzes and persisted attempts are connected."
            ) {
                HermosaStaticInfoCard {
                    Text("This screen already reflects persisted completion records, but richer breakdowns and review insights will come in a later milestone.")
                        .hermosaTextStyle(.body)
                        .foregroundStyle(HermosaColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .background(HermosaColors.backgroundBase)
    }

    private var completedCount: Int {
        lessonProgress.filter(\.isCompleted).count
    }

    private var completionRate: Double {
        guard curriculum.lessons.isEmpty == false else { return 0 }
        return Double(completedCount) / Double(curriculum.lessons.count)
    }

    private var lessonsWithScores: Int {
        lessonProgress.filter { $0.bestScore > 0 }.count
    }

    private var scoreRate: Double {
        guard curriculum.lessons.isEmpty == false else { return 0 }
        return Double(lessonsWithScores) / Double(curriculum.lessons.count)
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProgressViewScreen(curriculum: .placeholder, lessonProgress: [])
        }
    }
}
