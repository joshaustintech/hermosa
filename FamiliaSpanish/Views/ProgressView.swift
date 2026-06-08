import SwiftUI

struct ProgressViewScreen: View {
    let curriculum: Curriculum
    let lessonProgress: [LessonProgress]

    var body: some View {
        FamiliaScreenScrollView {
            FamiliaScreenHeader(
                title: "Progress",
                subtitle: "Track completed lessons and stay oriented as quiz persistence expands."
            )

            FamiliaProgressSummaryCard(
                title: "Completed Lessons",
                value: "\(completedCount)",
                detail: "\(curriculum.lessons.count) total lessons in the bundled curriculum.",
                progress: completionRate,
                tone: completedCount == 0 ? .neutral : .success
            )

            FamiliaProgressSummaryCard(
                title: "Best Scores Saved",
                value: "\(lessonsWithScores)",
                detail: "Lessons with at least one saved score in local progress data.",
                progress: scoreRate,
                tone: lessonsWithScores == 0 ? .neutral : .progress
            )

            FamiliaScreenSection(
                title: "Current Status",
                subtitle: "The full dashboard arrives after quizzes and persisted attempts are connected."
            ) {
                FamiliaStaticInfoCard {
                    Text("This screen already reflects persisted completion records, but richer breakdowns and review insights will come in a later milestone.")
                        .familiaTextStyle(.body)
                        .foregroundStyle(FamiliaColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .background(FamiliaColors.backgroundBase)
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

#Preview {
    NavigationStack {
        ProgressViewScreen(curriculum: .placeholder, lessonProgress: [])
    }
}
