import SwiftUI

struct LessonListView: View {
    @Environment(\.colorScheme) private var colorScheme
    let curriculum: Curriculum
    let lessonProgress: [LessonProgress]
    @Binding var quizInProgressLessonID: String?

    var body: some View {
        List {
            Section("Lessons") {
                ForEach(curriculum.lessons) { lesson in
                    let progress = progressRecord(for: lesson.id)

                    NavigationLink {
                        LessonDetailView(
                            lesson: lesson,
                            onStartQuiz: {
                                quizInProgressLessonID = lesson.id
                            }
                        )
                    } label: {
                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(lesson.title)
                                    .font(.headline)
                                Text("\(lesson.level.capitalized) • \(lesson.estimatedMinutes) min")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer(minLength: 12)

                            VStack(alignment: .trailing, spacing: 8) {
                                if progress?.isCompleted == true {
                                    Label("Done", systemImage: "checkmark.circle.fill")
                                        .font(.subheadline)
                                        .labelStyle(.iconOnly)
                                        .foregroundStyle(.green)
                                        .accessibilityLabel("Lesson completed")
                                }

                                if let bestScore = progress?.bestScore, bestScore > 0 {
                                    Text(bestScoreLabel(for: bestScore))
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(16)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: AppTheme.innerCornerRadius))
                        .overlay {
                            RoundedRectangle(cornerRadius: AppTheme.innerCornerRadius)
                                .strokeBorder(AppTheme.edgeGradient(for: colorScheme), lineWidth: 1.2)
                        }
                        .contentShape(RoundedRectangle(cornerRadius: AppTheme.innerCornerRadius))
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.clear)
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

    private func bestScoreLabel(for score: Double) -> String {
        "Best \(score.formatted(.percent.precision(.fractionLength(0))))"
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
