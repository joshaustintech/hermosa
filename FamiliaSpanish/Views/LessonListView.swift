import SwiftUI

struct LessonListView: View {
    let curriculum: Curriculum
    let lessonProgress: [LessonProgress]
    @Binding var selectedLessonID: String?
    @Binding var quizInProgressLessonID: String?

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(curriculum.title)
                        .font(.headline)
                    Text("Milestone 1 placeholder content is rendering from in-memory lesson data until XML parsing is implemented.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

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
                            VStack(alignment: .leading, spacing: 4) {
                                Text(lesson.title)
                                    .font(.headline)
                                Text("\(lesson.level.capitalized) • \(lesson.estimatedMinutes) min")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 6) {
                                if progress?.isCompleted == true {
                                    Label("Done", systemImage: "checkmark.circle.fill")
                                        .labelStyle(.iconOnly)
                                        .foregroundStyle(.green)
                                        .accessibilityLabel("Lesson completed")
                                }

                                if let bestScore = progress?.bestScore, bestScore > 0 {
                                    Text("\(bestScore.formatted(.percent.precision(.fractionLength(0))))")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            selectedLessonID = lesson.id
                        }
                    )
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
