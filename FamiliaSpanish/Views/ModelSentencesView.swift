import SwiftUI

struct ModelSentencesView: View {
    let sentences: [ModelSentence]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Model Sentences")
                .font(.title3.bold())

            ForEach(sentences) { sentence in
                VStack(alignment: .leading, spacing: 6) {
                    Text(sentence.spanish)
                        .font(.headline)
                        .textSelection(.enabled)
                    Text(sentence.english)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding(AppTheme.contentPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
    }
}
