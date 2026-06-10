import SwiftUI

struct VocabularyFlashcardsView: View {
    let title: String
    let cards: [HermosaFlashcard]

    init(lesson: Lesson) {
        title = "Vocabulary Flashcards"
        cards = lesson.vocabularyFlashcards
    }

    init(curriculum: Curriculum) {
        title = "All Vocabulary Flashcards"
        cards = curriculum.vocabularyFlashcards
    }

    var body: some View {
        HermosaFlashcardStudyView(
            title: title,
            cards: cards
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
