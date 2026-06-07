import SwiftUI

struct LessonListView: View {
    let curriculum: Curriculum
    let lessonProgress: [LessonProgress]
    @Binding var selectedLessonID: String?
    @Binding var quizInProgressLessonID: String?

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Text(curriculum.title)
                        .font(.title2.bold())
                    Text(curriculum.goal)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                    Label("\(curriculum.lessons.count) bundled lessons", systemImage: "book.closed")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(AppTheme.contentPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
            }
            .listRowInsets(EdgeInsets(top: 12, leading: 20, bottom: 8, trailing: 20))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

            Section("Lessons") {
                ForEach(curriculum.lessons) { lesson in
                    let progress = lessonProgress.first { $0.lessonID == lesson.id }

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
                                    Text("\(bestScore.formatted(.percent.precision(.fractionLength(0))))")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(16)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: AppTheme.innerCornerRadius))
                        .overlay {
                            RoundedRectangle(cornerRadius: AppTheme.innerCornerRadius)
                                .strokeBorder(.white.opacity(0.08))
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
}

#Preview {
    NavigationStack {
        LessonListView(
            curriculum: .placeholder,
            lessonProgress: [],
            selectedLessonID: .constant(nil),
            quizInProgressLessonID: .constant(nil)
        )
    }
}
