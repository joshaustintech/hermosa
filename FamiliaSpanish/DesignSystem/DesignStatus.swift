import Foundation

enum FamiliaLessonProgressState: Equatable {
    case notStarted
    case inProgress(bestScore: Double?)
    case completed(bestScore: Double?)
}

enum FamiliaQuizOptionState: Equatable {
    case idle
    case selected
    case correct
    case incorrect
    case disabled
}

enum FamiliaProgressTone {
    case neutral
    case progress
    case success
    case warning
    case error
}
