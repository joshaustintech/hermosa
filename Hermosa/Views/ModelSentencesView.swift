import SwiftUI

struct ModelSentencesView: View {
    let sentences: [ModelSentence]

    var body: some View {
        HermosaScreenSection(
            title: "Model Sentences",
            subtitle: "Read the Spanish first, then check the translation."
        ) {
            HermosaStackedCardGroup {
                ForEach(sentences) { sentence in
                    HermosaModelSentenceBlock(sentence: sentence)
                }
            }
        }
    }
}

#Preview("Model Sentences") {
    HermosaScreenScrollView {
        ModelSentencesView(sentences: Curriculum.placeholder.lessons[0].modelSentences)
    }
}
