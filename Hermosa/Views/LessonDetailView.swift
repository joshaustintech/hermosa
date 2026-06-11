import SwiftUI
import SwiftData

struct LessonDetailView: View {
    let lesson: Lesson
    let onStartQuiz: () -> Void

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        HermosaScreenScrollView {
            HermosaScreenHeader(
                title: lesson.title,
                subtitle: lesson.context
            )

            HermosaStaticInfoCard {
                VStack(alignment: .leading, spacing: HermosaMetrics.space8) {
                    Text("\(lesson.level.capitalized) • \(lesson.estimatedMinutes) minutes")
                        .hermosaTextStyle(.secondaryBody)
                        .foregroundStyle(HermosaColors.textSecondary)

                    Text(lesson.title)
                        .hermosaTextStyle(.cardTitle)
                        .foregroundStyle(HermosaColors.textPrimary)

                    Text(lesson.context)
                        .hermosaTextStyle(.body)
                        .foregroundStyle(HermosaColors.textSecondary)
                        .textSelection(.enabled)
                }
            }

            GrammarFocusView(items: lesson.grammarFocus)
            VocabularyView(words: lesson.vocabulary)
            ModelSentencesView(sentences: lesson.modelSentences)

            if lesson.vocabularyFlashcards.isEmpty == false || lesson.phraseFlashcards.isEmpty == false {
                HermosaScreenSection(
                    title: "Flashcards",
                    subtitle: "Review this lesson with a stacked deck that flips vertically and cycles horizontally."
                ) {
                    HermosaStackedCardGroup {
                        if lesson.vocabularyFlashcards.isEmpty == false {
                            NavigationLink {
                                VocabularyFlashcardsView(lesson: lesson) {
                                    incrementTimesReviewed(for: lesson.id)
                                }
                            } label: {
                                HermosaNavigationRow(
                                    title: "Vocabulary Deck",
                                    subtitle: "Spanish on the front, English and part of speech on the back.",
                                    badge: "\(lesson.vocabularyFlashcards.count) cards",
                                    systemImage: "rectangle.stack"
                                )
                            }
                            .buttonStyle(.plain)
                        }

                        if lesson.phraseFlashcards.isEmpty == false {
                            NavigationLink {
                                PhraseFlashcardsView(lesson: lesson) {
                                    incrementTimesReviewed(for: lesson.id)
                                }
                            } label: {
                                HermosaNavigationRow(
                                    title: "Phrase Deck",
                                    subtitle: "Short conversational phrases from this lesson’s model sentences.",
                                    badge: "\(lesson.phraseFlashcards.count) cards",
                                    systemImage: "quote.bubble"
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }

            Button("Start Quiz", systemImage: "play.circle.fill", action: onStartQuiz)
                .buttonStyle(HermosaPrimaryButtonStyle())
                .accessibilityHint("Opens the lesson quiz.")
        }
        .background(HermosaColors.backgroundBase)
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

struct LessonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonDetailView(lesson: Curriculum.placeholder.lessons[0], onStartQuiz: {})
    }
}
