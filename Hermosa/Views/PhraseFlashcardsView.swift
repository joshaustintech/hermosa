import SwiftUI

struct PhraseFlashcardsView: View {
    let title: String
    let cards: [HermosaFlashcard]
    var onComplete: (() -> Void)? = nil

    init(lesson: Lesson, onComplete: (() -> Void)? = nil) {
        title = "Phrase Flashcards"
        cards = lesson.phraseFlashcards
        self.onComplete = onComplete
    }

    init(curriculum: Curriculum) {
        title = "All Phrase Flashcards"
        cards = curriculum.phraseFlashcards
        self.onComplete = nil
    }

    var body: some View {
        HermosaFlashcardStudyView(
            title: title,
            cards: cards,
            onComplete: onComplete
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
