import SwiftUI

struct VocabularyView: View {
    let words: [VocabularyWord]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Vocabulary")
                .font(.title3.bold())

            ForEach(words) { word in
                VStack(alignment: .leading, spacing: 4) {
                    Text(word.spanish)
                        .font(.headline)
                    Text(word.english)
                        .foregroundStyle(.secondary)
                    Text(word.partOfSpeech)
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)
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
