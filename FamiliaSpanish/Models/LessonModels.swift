import Foundation

struct Curriculum: Identifiable, Equatable, Hashable {
    let id: String
    let title: String
    let version: String
    let goal: String
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

extension Curriculum {
    static let placeholder = Curriculum(
        id: "placeholder-curriculum",
        title: "Familia Spanish",
        version: "preview",
        goal: "Practice practical Spanish for family, food, Chicago, and church conversations.",
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
