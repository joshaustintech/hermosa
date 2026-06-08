import SwiftUI

struct LessonListView: View {
    let curriculum: Curriculum
    let lessonProgress: [LessonProgress]
    @Binding var quizInProgressLessonID: String?

    var body: some View {
        FamiliaScreenScrollView {
            FamiliaScreenSection {
                Text("Study practical Spanish through calm, readable lesson sets.")
                    .familiaTextStyle(.body)
                    .foregroundStyle(FamiliaColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                FamiliaStackedCardGroup {
                    ForEach(curriculum.lessons) { lesson in
                        NavigationLink {
                            LessonDetailView(
                                lesson: lesson,
                                onStartQuiz: {
                                    quizInProgressLessonID = lesson.id
                                }
                            )
                        } label: {
                            FamiliaLessonRow(
                                title: lesson.title,
                                metadata: "\(lesson.level.capitalized) • \(lesson.estimatedMinutes) min",
                                progressState: progressState(for: lesson.id)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .navigationDestination(item: quizLessonBinding) { lesson in
            QuizView(lesson: lesson)
        }
    }

    private var quizLessonBinding: Binding<Lesson?> {
        Binding(
            get: {
                guard let quizInProgressLessonID else { return nil }
                return curriculum.lessons.first { $0.id == quizInProgressLessonID }
            },
            set: { lesson in
                quizInProgressLessonID = lesson?.id
            }
        )
    }

    private func progressRecord(for lessonID: String) -> LessonProgress? {
        lessonProgress.first { $0.lessonID == lessonID }
    }

    private func progressState(for lessonID: String) -> FamiliaLessonProgressState {
        guard let progress = progressRecord(for: lessonID) else {
            return .notStarted
        }

        let bestScore = progress.bestScore > 0 ? progress.bestScore : nil

        if progress.isCompleted {
            return .completed(bestScore: bestScore)
        }

        if progress.lastScore > 0 || progress.timesReviewed > 0 || bestScore != nil {
            return .inProgress(bestScore: bestScore)
        }

        return .notStarted
    }
}

#Preview {
    NavigationStack {
        LessonListView(
            curriculum: .placeholder,
            lessonProgress: [],
            quizInProgressLessonID: .constant(nil)
        )
    }
}
