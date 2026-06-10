import SwiftUI

struct PhraseFlashcardsView: View {
    let title: String
    let cards: [HermosaFlashcard]

    init(lesson: Lesson) {
        title = "Phrase Flashcards"
        cards = lesson.phraseFlashcards
    }

    init(curriculum: Curriculum) {
        title = "All Phrase Flashcards"
        cards = curriculum.phraseFlashcards
    }

    var body: some View {
        HermosaFlashcardStudyView(
            title: title,
            cards: cards
        )
    }
}

struct PhraseFlashcardsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PhraseFlashcardsView(lesson: Curriculum.placeholder.lessons[0])
        }
    }
}
