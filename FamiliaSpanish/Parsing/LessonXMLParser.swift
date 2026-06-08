import Foundation

enum LessonXMLParser {
    static func bundledCurriculum() throws -> Curriculum {
        try parse(data: bundledLessonPlanData())
    }

    static func bundledLessonPlanData() throws -> Data {
        guard let url = Bundle.main.url(forResource: "lesson_plan", withExtension: "xml") else {
            throw ParserError.missingBundleResource
        }

        return try Data(contentsOf: url)
    }

    static func parse(data: Data) throws -> Curriculum {
        let delegate = CurriculumParserDelegate()
        let parser = XMLParser(data: data)
        parser.delegate = delegate

        guard parser.parse() else {
            if let parserError = delegate.parserError {
                throw parserError
            }

            throw ParserError.parseFailed(
                line: parser.lineNumber,
                reason: parser.parserError?.localizedDescription ?? "Unknown XML parsing failure."
            )
        }

        guard let curriculum = delegate.curriculum else {
            throw ParserError.parseFailed(
                line: parser.lineNumber,
                reason: "The XML finished parsing without producing a curriculum."
            )
        }

        return curriculum
    }

    enum ParserError: LocalizedError {
        case missingBundleResource
        case missingAttribute(element: String, attribute: String, line: Int)
        case invalidNumber(element: String, attribute: String, value: String, line: Int)
        case incompleteLesson(id: String, line: Int)
        case incompleteQuestion(prompt: String, line: Int)
        case parseFailed(line: Int, reason: String)

        var errorDescription: String? {
            switch self {
            case .missingBundleResource:
                return "The bundled lesson_plan.xml file could not be found."
            case let .missingAttribute(element, attribute, line):
                return "Missing required attribute '\(attribute)' on \(element) at line \(line)."
            case let .invalidNumber(element, attribute, value, line):
                return "Invalid numeric value '\(value)' for \(attribute) on \(element) at line \(line)."
            case let .incompleteLesson(id, line):
                return "Lesson \(id) is incomplete or malformed near line \(line)."
            case let .incompleteQuestion(prompt, line):
                return "Quiz question '\(prompt)' is incomplete or malformed near line \(line)."
            case let .parseFailed(line, reason):
                return "Lesson XML parsing failed at line \(line): \(reason)"
            }
        }
    }
}

private final class CurriculumParserDelegate: NSObject, XMLParserDelegate {
    private struct LessonBuilder {
        let id: String
        let title: String
        let level: String
        let estimatedMinutes: Int
        var context = ""
        var grammarFocus: [String] = []
        var vocabulary: [VocabularyWord] = []
        var modelSentences: [ModelSentence] = []
        var quiz: [QuizQuestion] = []

        func build(line: Int) throws -> Lesson {
            guard !context.isEmpty else {
                throw LessonXMLParser.ParserError.incompleteLesson(id: id, line: line)
            }

            return Lesson(
                id: id,
                title: title,
                level: level,
                estimatedMinutes: estimatedMinutes,
                context: context,
                grammarFocus: grammarFocus,
                vocabulary: vocabulary,
                modelSentences: modelSentences,
                quiz: quiz
            )
        }
    }

    private struct QuestionBuilder {
        let prompt: String
        let answer: String?
        let answers: [String]
        var options: [String] = []

        static func multipleChoice(prompt: String, answer: String) -> Self { .init(prompt: prompt, answer: answer, answers: []) }
        static func multipleSelect(prompt: String, answers: [String]) -> Self { .init(prompt: prompt, answer: nil, answers: answers) }

        mutating func appendOption(_ option: String) {
            options.append(option)
        }

        func build(line: Int) throws -> QuizQuestion {
            if let answer {
                guard !prompt.isEmpty, !answer.isEmpty, !options.isEmpty else {
                    throw LessonXMLParser.ParserError.incompleteQuestion(prompt: prompt, line: line)
                }

                return .multipleChoice(prompt: prompt, options: options, answer: answer)
            }

            guard !prompt.isEmpty, !answers.isEmpty, !options.isEmpty else {
                throw LessonXMLParser.ParserError.incompleteQuestion(prompt: prompt, line: line)
            }

            return .multipleSelect(prompt: prompt, options: options, answers: answers)
        }
    }

    var curriculum: Curriculum?
    var parserError: LessonXMLParser.ParserError?

    private var curriculumID = ""
    private var curriculumVersion = ""
    private var lessons: [Lesson] = []

    private var currentLesson: LessonBuilder?
    private var currentQuestion: QuestionBuilder?
    private var currentText = ""

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        currentText = ""

        handle(parser) {
            switch elementName {
            case "SpanishLearningCurriculum":
                curriculumID = try requiredAttribute("id", in: elementName, from: attributeDict, parser: parser)
                curriculumVersion = try requiredAttribute("version", in: elementName, from: attributeDict, parser: parser)

            case "Lesson":
                let id = try requiredAttribute("id", in: elementName, from: attributeDict, parser: parser)
                let title = try requiredAttribute("title", in: elementName, from: attributeDict, parser: parser)
                let level = try requiredAttribute("level", in: elementName, from: attributeDict, parser: parser)
                let estimatedMinutesValue = try requiredAttribute("estimatedMinutes", in: elementName, from: attributeDict, parser: parser)
                guard let estimatedMinutes = Int(estimatedMinutesValue) else {
                    throw LessonXMLParser.ParserError.invalidNumber(
                        element: elementName,
                        attribute: "estimatedMinutes",
                        value: estimatedMinutesValue,
                        line: parser.lineNumber
                    )
                }

                currentLesson = LessonBuilder(
                    id: id,
                    title: title,
                    level: level,
                    estimatedMinutes: estimatedMinutes
                )

            case "Word":
                try updateLesson {
                    $0.vocabulary.append(
                    VocabularyWord(
                        spanish: try requiredAttribute("spanish", in: elementName, from: attributeDict, parser: parser),
                        english: try requiredAttribute("english", in: elementName, from: attributeDict, parser: parser),
                        partOfSpeech: try requiredAttribute("partOfSpeech", in: elementName, from: attributeDict, parser: parser)
                    )
                    )
                }

            case "Sentence":
                try updateLesson {
                    $0.modelSentences.append(
                    ModelSentence(
                        spanish: try requiredAttribute("spanish", in: elementName, from: attributeDict, parser: parser),
                        english: try requiredAttribute("english", in: elementName, from: attributeDict, parser: parser)
                    )
                    )
                }

            case "MultipleChoice":
                currentQuestion = .multipleChoice(
                    prompt: try requiredAttribute("prompt", in: elementName, from: attributeDict, parser: parser),
                    answer: try requiredAttribute("answer", in: elementName, from: attributeDict, parser: parser)
                )

            case "MultipleSelect":
                let answers = try splitAnswers(from: attributeDict, element: elementName, parser: parser)
                currentQuestion = .multipleSelect(
                    prompt: try requiredAttribute("prompt", in: elementName, from: attributeDict, parser: parser),
                    answers: answers
                )

            default:
                break
            }
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentText += string
    }

    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        let text = currentText.trimmingCharacters(in: .whitespacesAndNewlines)

        handle(parser) {
            switch elementName {
            case "Context":
                updateLesson { $0.context = text }

            case "Item":
                guard !text.isEmpty else { return }
                updateLesson { $0.grammarFocus.append(text) }

            case "Option":
                guard !text.isEmpty else { return }
                currentQuestion?.appendOption(text)

            case "MultipleChoice", "MultipleSelect":
                guard var lesson = currentLesson, let question = currentQuestion else { return }
                lesson.quiz.append(try question.build(line: parser.lineNumber))
                currentLesson = lesson
                currentQuestion = nil

            case "Lesson":
                guard let lessonBuilder = currentLesson else { return }
                lessons.append(try lessonBuilder.build(line: parser.lineNumber))
                currentLesson = nil

            case "SpanishLearningCurriculum":
                curriculum = Curriculum(
                    id: curriculumID,
                    version: curriculumVersion,
                    lessons: lessons
                )

            default:
                break
            }
        }

        currentText = ""
    }

    private func handle(_ parser: XMLParser, _ body: () throws -> Void) {
        do {
            try body()
        } catch let error as LessonXMLParser.ParserError {
            parserError = error
            parser.abortParsing()
        } catch {
            parserError = .parseFailed(line: parser.lineNumber, reason: error.localizedDescription)
            parser.abortParsing()
        }
    }

    private func updateLesson(_ update: (inout LessonBuilder) throws -> Void) rethrows {
        guard var lesson = currentLesson else { return }
        try update(&lesson)
        currentLesson = lesson
    }

    private func splitAnswers(from attributes: [String: String], element: String, parser: XMLParser) throws -> [String] {
        try requiredAttribute("answers", in: element, from: attributes, parser: parser)
            .split(separator: "|")
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    private func requiredAttribute(
        _ attribute: String,
        in element: String,
        from attributes: [String: String],
        parser: XMLParser
    ) throws -> String {
        guard let value = attributes[attribute], !value.isEmpty else {
            throw LessonXMLParser.ParserError.missingAttribute(
                element: element,
                attribute: attribute,
                line: parser.lineNumber
            )
        }

        return value
    }
}
