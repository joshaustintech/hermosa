import Foundation
import SwiftData

@Model
final class LessonProgress {
    @Attribute(.unique) var lessonID: String
    var isCompleted: Bool
    var bestScore: Double
    var lastScore: Double
    var timesReviewed: Int
    var completedAt: Date?
    var lastReviewedAt: Date?

    init(
        lessonID: String,
        isCompleted: Bool = false,
        bestScore: Double = 0,
        lastScore: Double = 0,
        timesReviewed: Int = 0,
        completedAt: Date? = nil,
        lastReviewedAt: Date? = nil
    ) {
        self.lessonID = lessonID
        self.isCompleted = isCompleted
        self.bestScore = bestScore
        self.lastScore = lastScore
        self.timesReviewed = timesReviewed
        self.completedAt = completedAt
        self.lastReviewedAt = lastReviewedAt
    }
}

@Model
final class QuizAttempt {
    var lessonID: String
    var score: Double
    var correctCount: Int
    var totalCount: Int
    var attemptedAt: Date

    init(
        lessonID: String,
        score: Double,
        correctCount: Int,
        totalCount: Int,
        attemptedAt: Date = .now
    ) {
        self.lessonID = lessonID
        self.score = score
        self.correctCount = correctCount
        self.totalCount = totalCount
        self.attemptedAt = attemptedAt
    }
}
