import Foundation

enum LessonXMLParser {
    static func bundledLessonPlanData() throws -> Data {
        guard let url = Bundle.main.url(forResource: "lesson_plan", withExtension: "xml") else {
            throw ParserError.missingBundleResource
        }

        return try Data(contentsOf: url)
    }

    enum ParserError: LocalizedError {
        case missingBundleResource

        var errorDescription: String? {
            switch self {
            case .missingBundleResource:
                "The bundled lesson_plan.xml file could not be found."
            }
        }
    }
}
