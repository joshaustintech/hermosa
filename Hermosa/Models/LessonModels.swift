import Foundation

struct Curriculum: Identifiable, Equatable, Hashable {
    let id: String
    let version: String
    let lessons: [Lesson]
}

struct Lesson: Identifiable, Equatable, Hashable {
    let id: String
    let title: String
    let level: String
    let estimatedMinutes: Int
    let context: String
    let grammarFocus: [String]
    let vocabulary: [VocabularyWord]
    let modelSentences: [ModelSentence]
    let quiz: [QuizQuestion]
}

struct VocabularyWord: Identifiable, Equatable, Hashable {
    let id = UUID()
    let spanish: String
    let english: String
    let partOfSpeech: String
}

struct ModelSentence: Identifiable, Equatable, Hashable {
    let id = UUID()
    let spanish: String
    let english: String
}

enum QuizQuestion: Identifiable, Equatable, Hashable {
    case multipleChoice(prompt: String, options: [String], answer: String)
    case multipleSelect(prompt: String, options: [String], answers: [String])

    var id: String {
        switch self {
        case let .multipleChoice(prompt, _, _):
            prompt
        case let .multipleSelect(prompt, _, _):
            prompt
        }
    }
}

struct HermosaFlashcard: Identifiable, Equatable, Hashable {
    enum Kind: String, Equatable, Hashable {
        case vocabulary = "Vocabulary"
        case shortPhrase = "Short Phrase"
    }

    let id: String
    let lessonID: String
    let lessonTitle: String
    let kind: Kind
    let frontText: String
    let frontDetail: String?
    let backText: String
    let backDetail: String?
}

extension Lesson {
    var vocabularyFlashcards: [HermosaFlashcard] {
        vocabulary
            .filter { $0.partOfSpeech.caseInsensitiveCompare("phrase") != .orderedSame }
            .map { word in
                HermosaFlashcard(
                    id: "vocabulary-\(id)-\(word.spanish)-\(word.english)",
                    lessonID: id,
                    lessonTitle: title,
                    kind: .vocabulary,
                    frontText: word.spanish,
                    frontDetail: nil,
                    backText: word.english,
                    backDetail: word.partOfSpeech
                )
            }
    }

    var phraseFlashcards: [HermosaFlashcard] {
        let vocabularyPhraseCards = vocabulary
            .filter { $0.partOfSpeech.caseInsensitiveCompare("phrase") == .orderedSame }
            .map { word in
                HermosaFlashcard(
                    id: "phrase-vocabulary-\(id)-\(word.spanish)-\(word.english)",
                    lessonID: id,
                    lessonTitle: title,
                    kind: .shortPhrase,
                    frontText: word.spanish,
                    frontDetail: nil,
                    backText: word.english,
                    backDetail: "Vocabulary phrase"
                )
            }

        let modelSentenceCards = modelSentences.map { sentence in
            HermosaFlashcard(
                id: "phrase-\(id)-\(sentence.spanish)-\(sentence.english)",
                lessonID: id,
                lessonTitle: title,
                kind: .shortPhrase,
                frontText: sentence.spanish,
                frontDetail: nil,
                backText: sentence.english,
                backDetail: "Lesson phrase"
            )
        }

        return vocabularyPhraseCards + modelSentenceCards
    }
}

extension Curriculum {
    var vocabularyFlashcards: [HermosaFlashcard] {
        lessons.flatMap(\.vocabularyFlashcards)
    }

    var phraseFlashcards: [HermosaFlashcard] {
        lessons.flatMap(\.phraseFlashcards)
    }
}

extension Curriculum {
    static let placeholder = Curriculum(
        id: "placeholder-curriculum",
        version: "preview",
        lessons: [
            Lesson(
                id: "L01",
                title: "Greetings, Courtesy, and Introductions",
                level: "beginner",
                estimatedMinutes: 20,
                context: "Meeting extended relatives at a family gathering.",
                grammarFocus: [
                    "Subject pronouns",
                    "Formal vs informal address",
                    "Basic sentence pattern"
                ],
                vocabulary: [
                    VocabularyWord(spanish: "hola", english: "hello", partOfSpeech: "interjection"),
                    VocabularyWord(spanish: "gracias", english: "thank you", partOfSpeech: "interjection")
                ],
                modelSentences: [
                    ModelSentence(spanish: "Hola, me llamo Josh.", english: "Hello, my name is Josh."),
                    ModelSentence(spanish: "Mucho gusto.", english: "Nice to meet you.")
                ],
                quiz: [
                    .multipleChoice(
                        prompt: "What does 'mucho gusto' mean?",
                        options: ["Nice to meet you", "Good night", "Please", "Excuse me"],
                        answer: "Nice to meet you"
                    )
                ]
            )
        ]
    )
}
