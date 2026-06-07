import SwiftUI

struct VocabularyView: View {
    @Environment(\.colorScheme) private var colorScheme
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
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(AppTheme.edgeGradient(for: colorScheme), lineWidth: 1)
                }
            }
        }
        .padding(AppTheme.contentPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius)
                .strokeBorder(AppTheme.edgeGradient(for: colorScheme), lineWidth: 1.1)
        }
    }
}
