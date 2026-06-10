import Foundation

enum HermosaLessonProgressState: Equatable {
    case notStarted
    case inProgress(bestScore: Double?)
    case completed(bestScore: Double?)
}

enum HermosaQuizOptionState: Equatable {
    case idle
    case selected
    case correct
    case incorrect
    case disabled
}

enum HermosaProgressTone {
    case neutral
    case progress
    case success
}
