import SwiftUI

struct ModelSentencesView: View {
    let sentences: [ModelSentence]

    var body: some View {
        FamiliaScreenSection(
            title: "Model Sentences",
            subtitle: "Read the Spanish first, then check the translation."
        ) {
            FamiliaStackedCardGroup {
                ForEach(sentences) { sentence in
                    FamiliaModelSentenceBlock(sentence: sentence)
                }
            }
        }
    }
}
