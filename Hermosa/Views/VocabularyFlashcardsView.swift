import SwiftUI

struct VocabularyFlashcardsView: View {
    let title: String
    let cards: [HermosaFlashcard]
    var onComplete: (() -> Void)? = nil

    init(lesson: Lesson, onComplete: (() -> Void)? = nil) {
        title = "Vocabulary Flashcards"
        cards = lesson.vocabularyFlashcards
        self.onComplete = onComplete
    }

    init(curriculum: Curriculum) {
        title = "All Vocabulary Flashcards"
        cards = curriculum.vocabularyFlashcards
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

struct VocabularyFlashcardsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VocabularyFlashcardsView(lesson: Curriculum.placeholder.lessons[0])
        }
    }
}
