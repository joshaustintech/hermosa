import SwiftUI

struct QuizQuestionPlaceholderRow: View {
    let question: QuizQuestion

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(prompt)
                .font(.headline)

            ForEach(options, id: \.self) { option in
                Label(option, systemImage: "circle")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
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
