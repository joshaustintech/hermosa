import SwiftUI

struct VocabularyView: View {
    let words: [VocabularyWord]

    var body: some View {
        FamiliaScreenSection(
            title: "Vocabulary",
            subtitle: "High-frequency words tied to this lesson."
        ) {
            FamiliaStackedCardGroup {
                ForEach(words) { word in
                    FamiliaVocabularyRow(word: word)
                }
            }
        }
    }
}
