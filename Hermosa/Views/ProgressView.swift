import SwiftUI
import SwiftData

struct ProgressViewScreen: View {
    let curriculum: Curriculum
    let lessonProgress: [LessonProgress]

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \QuizAttempt.attemptedAt, order: .reverse) private var quizAttempts: [QuizAttempt]

    @State private var selectedSegment = 0

    var body: some View {
        VStack(spacing: 0) {
            Picker("Progress Mode", selection: $selectedSegment) {
                Text("Dashboard").tag(0)
                Text("Review Queue").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, HermosaMetrics.screenPadding)
            .padding(.vertical, HermosaMetrics.space12)
            .background(HermosaColors.backgroundBase)

            Divider()
                .background(HermosaColors.divider)

            if selectedSegment == 0 {
                dashboardView
            } else {
                reviewQueueView
            }
        }
        .background(HermosaColors.backgroundBase)
    }

    private var dashboardView: some View {
        HermosaScreenScrollView {
            HermosaScreenHeader(
                title: "Progress Dashboard",
                subtitle: "Track completed lessons and quiz scores saved locally."
            )

            HermosaProgressSummaryCard(
                title: "Completed Lessons",
                value: "\(completedCount) / \(curriculum.lessons.count)",
                detail: "Completion rate across the bundled curriculum.",
                progress: completionRate,
                tone: completedCount == 0 ? .neutral : .success
            )

            HermosaProgressSummaryCard(
                title: "Average Quiz Score",
                value: averageBestScore > 0 ? "\(Int(averageBestScore * 100))%" : "N/A",
                detail: "Calculated across lessons with quiz attempts.",
                progress: averageBestScore,
                tone: averageBestScore == 0 ? .neutral : .progress
            )

            HermosaScreenSection(
                title: "Study Activity",
                subtitle: "Summary of review sessions completed."
            ) {
                HermosaStaticInfoCard {
                    HStack {
                        VStack(alignment: .leading, spacing: HermosaMetrics.space4) {
                            Text("Total Reviews")
                                .hermosaTextStyle(.bodyEmphasized)
                                .foregroundStyle(HermosaColors.textPrimary)
                            Text("Completed card review sessions")
                                .hermosaTextStyle(.secondaryBody)
                                .foregroundStyle(HermosaColors.textSecondary)
                        }
                        Spacer()
                        Text("\(totalReviewsCount)")
                            .hermosaTextStyle(.display)
                            .foregroundStyle(HermosaColors.accentPrimary)
                    }
                }
            }

            HermosaScreenSection(
                title: "Recent Quiz Attempts",
                subtitle: "Latest scores across all lessons."
            ) {
                if quizAttempts.isEmpty {
                    HermosaStaticInfoCard {
                        Text("No quiz attempts recorded yet. Go to the Lessons tab and complete a quiz to see your history here!")
                            .hermosaTextStyle(.body)
                            .foregroundStyle(HermosaColors.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                } else {
                    HermosaStackedCardGroup {
                        ForEach(quizAttempts.prefix(5)) { attempt in
                            HermosaQuizAttemptRow(
                                attempt: attempt,
                                lessonTitle: lessonTitle(for: attempt.lessonID)
                            )
                        }
                    }
                }
            }
        }
    }

    private var reviewQueueView: some View {
        HermosaScreenScrollView {
            HermosaScreenHeader(
                title: "Review Queue",
                subtitle: "Prioritized study suggestions to keep your Spanish sharp."
            )

            let recs = reviewRecommendations

            if recs.isEmpty {
                HermosaStatusCard(
                    title: "All Caught Up!",
                    message: "All lessons are completed, scored above 85%, and reviewed recently. Great job!",
                    systemImage: "checkmark.seal.fill",
                    imageColor: HermosaColors.success
                )
            } else {
                HermosaScreenSection(
                    title: "Study Recommendations",
                    subtitle: "Lessons prioritized by incomplete state, low scores, or time elapsed."
                ) {
                    HermosaStackedCardGroup {
                        ForEach(recs) { rec in
                            NavigationLink {
                                VocabularyFlashcardsView(lesson: rec.lesson) {
                                    incrementTimesReviewed(for: rec.lesson.id)
                                }
                            } label: {
                                HermosaNavigationRow(
                                    title: rec.lesson.title,
                                    subtitle: rec.reason,
                                    badge: "Review",
                                    systemImage: "rectangle.stack"
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }

    private var completedCount: Int {
        lessonProgress.filter(\.isCompleted).count
    }

    private var completionRate: Double {
        guard curriculum.lessons.isEmpty == false else { return 0 }
        return Double(completedCount) / Double(curriculum.lessons.count)
    }

    private var averageBestScore: Double {
        let scores = lessonProgress.map(\.bestScore).filter { $0 > 0 }
        guard !scores.isEmpty else { return 0 }
        return scores.reduce(0, +) / Double(scores.count)
    }

    private var totalReviewsCount: Int {
        lessonProgress.map(\.timesReviewed).reduce(0, +)
    }

    private func lessonTitle(for lessonID: String) -> String {
        curriculum.lessons.first { $0.id == lessonID }?.title ?? "Lesson \(lessonID)"
    }

    private struct ReviewRecommendation: Identifiable {
        var id: String { lesson.id }
        let lesson: Lesson
        let priority: Int
        let reason: String
    }

    private var reviewRecommendations: [ReviewRecommendation] {
        var results: [ReviewRecommendation] = []

        for lesson in curriculum.lessons {
            let progress = lessonProgress.first { $0.lessonID == lesson.id }

            if progress == nil || progress?.isCompleted == false {
                results.append(
                    ReviewRecommendation(
                        lesson: lesson,
                        priority: 1,
                        reason: "Incomplete"
                    )
                )
            } else if let progress, progress.isCompleted {
                if progress.bestScore < 0.85 {
                    results.append(
                        ReviewRecommendation(
                            lesson: lesson,
                            priority: 2,
                            reason: "Score below 85% (\(Int(progress.bestScore * 100))%)"
                        )
                    )
                } else {
                    let lastReviewed = progress.lastReviewedAt ?? progress.completedAt
                    if let lastReviewed {
                        let days = Calendar.current.dateComponents([.day], from: lastReviewed, to: Date()).day ?? 0
                        if days >= 7 {
                            results.append(
                                ReviewRecommendation(
                                    lesson: lesson,
                                    priority: 3,
                                    reason: "Not reviewed in \(days) days"
                                )
                            )
                        }
                    }
                }
            }
        }

        return results.sorted { $0.priority < $1.priority }
    }

    private func incrementTimesReviewed(for lessonID: String) {
        let descriptor = FetchDescriptor<LessonProgress>(
            predicate: #Predicate { $0.lessonID == lessonID }
        )
        do {
            let progress = try modelContext.fetch(descriptor).first ?? LessonProgress(lessonID: lessonID)
            if progress.modelContext == nil {
                modelContext.insert(progress)
            }
            progress.timesReviewed += 1
            progress.lastReviewedAt = Date()
            try modelContext.save()
        } catch {
            print("Failed to save review progress: \(error)")
        }
    }
}

struct HermosaQuizAttemptRow: View {
    let attempt: QuizAttempt
    let lessonTitle: String

    var body: some View {
        HStack(alignment: .center, spacing: HermosaMetrics.space12) {
            VStack(alignment: .leading, spacing: HermosaMetrics.space4) {
                Text(lessonTitle)
                    .hermosaTextStyle(.bodyEmphasized)
                    .foregroundStyle(HermosaColors.textPrimary)
                    .lineLimit(2)

                Text(attempt.attemptedAt.formatted(date: .abbreviated, time: .shortened))
                    .hermosaTextStyle(.metadata)
                    .foregroundStyle(HermosaColors.textSecondary)
            }

            Spacer(minLength: HermosaMetrics.space12)

            VStack(alignment: .trailing, spacing: HermosaMetrics.space4) {
                Text(attempt.score.formatted(.percent.precision(.fractionLength(0))))
                    .hermosaTextStyle(.cardTitle)
                    .foregroundStyle(attempt.score >= 0.7 ? HermosaColors.success : HermosaColors.accentPrimary)

                Text("\(attempt.correctCount)/\(attempt.totalCount)")
                    .hermosaTextStyle(.metadata)
                    .foregroundStyle(HermosaColors.textTertiary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .hermosaStaticCard()
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProgressViewScreen(curriculum: .placeholder, lessonProgress: [])
        }
        .modelContainer(for: [LessonProgress.self, QuizAttempt.self], inMemory: true)
    }
}
