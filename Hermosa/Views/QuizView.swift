import SwiftUI
import SwiftData
import UIKit

struct QuizView: View {
    let lesson: Lesson

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var session: QuizSession
    @State private var savedAttempt = false
    @State private var feedbackEventID: UUID?

    init(lesson: Lesson) {
        self.lesson = lesson
        _session = State(initialValue: QuizSession(lesson: lesson))
    }

    var body: some View {
        HermosaScreenScrollView {
            if let result = session.result {
                resultView(result: result)
            } else {
                activeQuestionView
            }
        }
        .background(HermosaColors.backgroundBase)
        .navigationTitle("Quiz")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            persistFinishedSessionIfNeeded()
        }
        .onChange(of: session.result != nil) { _, _ in
            persistFinishedSessionIfNeeded()
        }
        .onChange(of: session.feedback?.id) { _, newValue in
            guard let newValue, newValue != feedbackEventID else { return }
            feedbackEventID = newValue
            playFeedbackHaptic(for: session.feedback)
        }
    }

    private var activeQuestionView: some View {
        let question = session.questions[session.currentQuestionIndex]

        return VStack(alignment: .leading, spacing: HermosaMetrics.space24) {
            HermosaScreenHeader(
                title: lesson.title,
                subtitle: "Question \(session.currentQuestionIndex + 1) of \(session.questions.count)"
            )

            if let feedback = session.feedback, let outcome = session.currentOutcome {
                QuizAnswerFeedbackCard(
                    title: feedback.title,
                    message: feedback.message,
                    systemImage: feedback.systemImage,
                    imageColor: feedback.color,
                    outcome: outcome
                )
            } else {
                QuizQuestionCard(
                    question: question,
                    selection: session.selection,
                    onToggleOption: { optionID in
                        session.toggleSelection(for: optionID)
                    }
                )
            }

            if session.hasSubmittedAnswer {
                Button(
                    session.isLastQuestion ? "Finish Quiz" : "Next Question",
                    systemImage: session.isLastQuestion ? "checkmark.circle.fill" : "arrow.right.circle.fill",
                    action: {
                        session.advanceToNextQuestion()
                    }
                )
                .buttonStyle(HermosaPrimaryButtonStyle())
            } else {
                Button("Check Answer", systemImage: "checkmark.circle") {
                    session.submitCurrentAnswer()
                }
                    .buttonStyle(HermosaPrimaryButtonStyle())
                    .disabled(!session.canSubmitCurrentAnswer)
                    .accessibilityHint("Checks the selected answer for this question.")
            }
        }
    }

    private func resultView(result: QuizResult) -> some View {
        VStack(alignment: .leading, spacing: HermosaMetrics.space24) {
            HermosaScreenHeader(
                title: "Quiz Complete",
                subtitle: lesson.title
            )

            HermosaProgressSummaryCard(
                title: result.passed ? "Lesson Passed" : "Keep Practicing",
                value: result.score.formatted(.percent.precision(.fractionLength(0))),
                detail: "\(result.correctCount) of \(result.totalCount) correct",
                progress: result.score,
                tone: result.passed ? .success : .progress
            )

            HermosaStaticInfoCard(title: "Result") {
                VStack(alignment: .leading, spacing: HermosaMetrics.space8) {
                    Text(result.passed ? "This lesson now counts as completed." : "A score of 70% or higher marks the lesson complete.")
                        .hermosaTextStyle(.body)
                        .foregroundStyle(HermosaColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(savedAttempt ? "Your progress was saved locally." : "Saving progress...")
                        .hermosaTextStyle(.secondaryBody)
                        .foregroundStyle(HermosaColors.textTertiary)
                }
            }

            HermosaScreenSection(
                title: "Question Review",
                subtitle: "Correct answers are highlighted for quick review."
            ) {
                HermosaStackedCardGroup {
                    ForEach(result.reviewItems) { item in
                        QuizReviewCard(item: item)
                    }
                }
            }

            Button("Retake Quiz", systemImage: "arrow.clockwise") {
                session = QuizSession(lesson: lesson)
                savedAttempt = false
            }
            .buttonStyle(HermosaPrimaryButtonStyle())

            Button("Back to Lesson", systemImage: "chevron.left", action: dismiss.callAsFunction)
                .buttonStyle(HermosaPrimaryButtonStyle())
        }
    }

    private func persistFinishedSessionIfNeeded() {
        guard !savedAttempt, let result = session.result else { return }

        let attempt = QuizAttempt(
            lessonID: lesson.id,
            score: result.score,
            correctCount: result.correctCount,
            totalCount: result.totalCount
        )
        modelContext.insert(attempt)

        let lessonID = lesson.id
        let descriptor = FetchDescriptor<LessonProgress>(
            predicate: #Predicate { $0.lessonID == lessonID }
        )

        do {
            let progress = try modelContext.fetch(descriptor).first ?? LessonProgress(lessonID: lesson.id)
            if progress.modelContext == nil {
                modelContext.insert(progress)
            }

            progress.lastScore = result.score
            progress.bestScore = max(progress.bestScore, result.score)
            progress.lastReviewedAt = .now
            progress.timesReviewed += 1

            if result.passed {
                progress.isCompleted = true
                progress.completedAt = progress.completedAt ?? .now
            }

            try modelContext.save()
            savedAttempt = true
        } catch {
            assertionFailure("Failed to save quiz progress: \(error)")
        }
    }

    private func playFeedbackHaptic(for feedback: QuizFeedback?) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(feedback?.wasCorrect == true ? .success : .error)
    }
}

private struct QuizSession {
    let questions: [PresentedQuizQuestion]

    var currentQuestionIndex = 0
    var selection: Set<UUID> = []
    var feedback: QuizFeedback?
    var answers: [QuizOutcomeSnapshot] = []
    var result: QuizResult?

    init(lesson: Lesson) {
        questions = Self.presentedQuestions(from: lesson.quiz)
    }

    var currentQuestion: PresentedQuizQuestion {
        questions[currentQuestionIndex]
    }

    var hasSubmittedAnswer: Bool {
        feedback != nil
    }

    var canSubmitCurrentAnswer: Bool {
        switch currentQuestion.kind {
        case .multipleChoice:
            return selection.count == 1
        case .multipleSelect:
            return !selection.isEmpty
        }
    }

    var correctCount: Int {
        answers.filter(\.wasCorrect).count
    }

    var currentOutcome: QuizOutcomeSnapshot? {
        guard hasSubmittedAnswer else { return nil }
        return answers.last
    }

    var isLastQuestion: Bool {
        currentQuestionIndex == questions.index(before: questions.endIndex)
    }

    var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentQuestionIndex) / Double(questions.count)
    }

    mutating func toggleSelection(for optionID: UUID) {
        guard !hasSubmittedAnswer else { return }

        switch currentQuestion.kind {
        case .multipleChoice:
            selection = [optionID]
        case .multipleSelect:
            if selection.contains(optionID) {
                selection.remove(optionID)
            } else {
                selection.insert(optionID)
            }
        }
    }

    mutating func submitCurrentAnswer() {
        guard !hasSubmittedAnswer, canSubmitCurrentAnswer else { return }

        let question = currentQuestion
        let wasCorrect = selection == question.correctOptionIDs
        let selectedTitles = question.options
            .filter { selection.contains($0.id) }
            .map(\.title)

        let outcome = QuizOutcomeSnapshot(
            prompt: question.prompt,
            wasCorrect: wasCorrect,
            correctAnswerText: question.correctAnswerText,
            selectedAnswerText: selectedTitles.isEmpty ? nil : selectedTitles.joined(separator: ", ")
        )

        answers.append(outcome)
        feedback = QuizFeedback(
            wasCorrect: wasCorrect
        )
    }

    mutating func advanceToNextQuestion() {
        guard hasSubmittedAnswer else { return }

        if isLastQuestion {
            let totalCount = questions.count
            let score = totalCount == 0 ? 0 : Double(correctCount) / Double(totalCount)
            result = QuizResult(
                score: score,
                correctCount: correctCount,
                totalCount: totalCount,
                reviewItems: answers.map {
                    QuizReviewItem(
                        prompt: $0.prompt,
                        wasCorrect: $0.wasCorrect,
                        correctAnswerText: $0.correctAnswerText,
                        selectedAnswerText: $0.selectedAnswerText
                    )
                }
            )
            feedback = nil
            selection = []
            return
        }

        currentQuestionIndex += 1
        selection = []
        feedback = nil
    }

    private static func presentedQuestions(from questions: [QuizQuestion]) -> [PresentedQuizQuestion] {
        let multipleChoicePool = Set(
            questions.flatMap { question -> [String] in
                guard case let .multipleChoice(_, options, _) = question else { return [] }
                return options
            }
        )

        let multipleSelectPool = Set(
            questions.flatMap { question -> [String] in
                guard case let .multipleSelect(_, options, _) = question else { return [] }
                return options
            }
        )

        return questions.map { question in
            switch question {
            case let .multipleChoice(prompt, options, answer):
                let choiceCount = max(options.count, 2)
                let distractorPool = Array(multipleChoicePool.subtracting([answer]))
                let fallbackDistractors = options.filter { $0 != answer }
                let distractors = Array(
                    (distractorPool.isEmpty ? fallbackDistractors : distractorPool)
                        .shuffled()
                        .prefix(max(0, choiceCount - 1))
                )
                let presentedOptions = ([answer] + distractors)
                    .shuffled()
                    .map { PresentedQuizOption(title: $0) }
                let correctIDs = Set(presentedOptions.filter { $0.title == answer }.map(\.id))

                return PresentedQuizQuestion(
                    prompt: prompt,
                    kind: .multipleChoice,
                    options: presentedOptions,
                    correctOptionIDs: correctIDs
                )

            case let .multipleSelect(prompt, options, answers):
                let answerSet = Set(answers)
                let candidatePool = Array(multipleSelectPool.subtracting(answerSet))
                let fallbackPool = options.filter { !answerSet.contains($0) }
                let incorrectPool = (candidatePool.isEmpty ? fallbackPool : candidatePool).shuffled()
                let targetCount = max(options.count, answers.count)
                let incorrectTarget = max(0, targetCount - answers.count)
                let incorrectOptions = Array(incorrectPool.prefix(incorrectTarget))
                let presentedOptions = (answers + incorrectOptions)
                    .shuffled()
                    .map { PresentedQuizOption(title: $0) }
                let correctIDs = Set(presentedOptions.filter { answerSet.contains($0.title) }.map(\.id))

                return PresentedQuizQuestion(
                    prompt: prompt,
                    kind: .multipleSelect,
                    options: presentedOptions,
                    correctOptionIDs: correctIDs
                )
            }
        }
    }
}

struct PresentedQuizQuestion: Identifiable {
    let id = UUID()
    let prompt: String
    let kind: QuestionKind
    let options: [PresentedQuizOption]
    let correctOptionIDs: Set<UUID>

    var correctAnswerText: String {
        options
            .filter { correctOptionIDs.contains($0.id) }
            .map(\.title)
            .joined(separator: ", ")
    }
}

struct PresentedQuizOption: Identifiable {
    let id = UUID()
    let title: String
}

enum QuestionKind {
    case multipleChoice
    case multipleSelect

    var title: String {
        switch self {
        case .multipleChoice:
            "Multiple Choice"
        case .multipleSelect:
            "Multi-Select"
        }
    }

    var subtitle: String {
        switch self {
        case .multipleChoice:
            "Choose the single best answer."
        case .multipleSelect:
            "Select every answer that applies."
        }
    }
}

struct QuizOutcomeSnapshot {
    let prompt: String
    let wasCorrect: Bool
    let correctAnswerText: String
    let selectedAnswerText: String?
}

struct QuizFeedback {
    let id = UUID()
    let wasCorrect: Bool

    var title: String {
        wasCorrect ? "Correct" : "Not Quite"
    }

    var message: String {
        wasCorrect ? "You can move on when you’re ready." : "Review the highlighted answer, then continue."
    }

    var systemImage: String {
        wasCorrect ? "checkmark.circle.fill" : "xmark.circle.fill"
    }

    var color: Color {
        wasCorrect ? HermosaColors.success : HermosaColors.error
    }
}

private struct QuizResult {
    let score: Double
    let correctCount: Int
    let totalCount: Int
    let reviewItems: [QuizReviewItem]

    var passed: Bool {
        score >= 0.7
    }
}

struct QuizReviewItem: Identifiable {
    let id = UUID()
    let prompt: String
    let wasCorrect: Bool
    let correctAnswerText: String
    let selectedAnswerText: String?

    var statusText: String {
        wasCorrect ? "Answered correctly" : "Answered incorrectly"
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            QuizView(lesson: Curriculum.placeholder.lessons[0])
        }
        .modelContainer(for: [LessonProgress.self, QuizAttempt.self], inMemory: true)
    }
}
