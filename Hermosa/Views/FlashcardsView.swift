import SwiftUI

struct FlashcardsView: View {
    let curriculum: Curriculum

    var body: some View {
        HermosaScreenScrollView {
            HermosaScreenHeader(
                title: "Flashcards",
                subtitle: "Review vocabulary and short phrases across the bundled curriculum."
            )

            HermosaScreenSection(
                title: "All Lessons",
                subtitle: "Choose a deck to review across the full curriculum."
            ) {
                HermosaStackedCardGroup {
                    if curriculum.vocabularyFlashcards.isEmpty == false {
                        NavigationLink {
                            VocabularyFlashcardsView(curriculum: curriculum)
                        } label: {
                            HermosaNavigationRow(
                                title: "Vocabulary Deck",
                                subtitle: "Cycle through vocabulary from every bundled lesson.",
                                badge: "\(curriculum.vocabularyFlashcards.count) cards",
                                systemImage: "rectangle.stack.fill"
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    if curriculum.phraseFlashcards.isEmpty == false {
                        NavigationLink {
                            PhraseFlashcardsView(curriculum: curriculum)
                        } label: {
                            HermosaNavigationRow(
                                title: "Phrase Deck",
                                subtitle: "Review short conversational phrases from lessons across the app.",
                                badge: "\(curriculum.phraseFlashcards.count) cards",
                                systemImage: "text.quote"
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .background(HermosaColors.backgroundBase)
    }
}

struct FlashcardsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FlashcardsView(curriculum: .placeholder)
        }
    }
}
