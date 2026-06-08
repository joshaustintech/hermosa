import SwiftUI

struct QuizQuestionPlaceholderRow: View {
    let question: QuizQuestion

    var body: some View {
        VStack(alignment: .leading, spacing: FamiliaMetrics.space12) {
            Text(prompt)
                .familiaTextStyle(.cardTitle)
                .foregroundStyle(FamiliaColors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)

            ForEach(options, id: \.self) { option in
                FamiliaQuizOptionRow(
                    title: option,
                    state: .idle
                )
            }
        }
        .familiaStaticCard()
    }

    private var prompt: String {
        switch question {
        case let .multipleChoice(prompt, _, _):
            prompt
        case let .multipleSelect(prompt, _, _):
            prompt
        }
    }

    private var options: [String] {
        switch question {
        case let .multipleChoice(_, options, _):
            options
        case let .multipleSelect(_, options, _):
            options
        }
    }
}
