import SwiftUI

struct VocabularyView: View {
    let words: [VocabularyWord]

    var body: some View {
        HermosaScreenSection(
            title: "Vocabulary",
            subtitle: "High-frequency words tied to this lesson."
        ) {
            HermosaStackedCardGroup {
                ForEach(words) { word in
                    HermosaVocabularyRow(word: word)
                }
            }
        }
    }
}

#Preview("Vocabulary") {
    HermosaScreenScrollView {
        VocabularyView(words: Curriculum.placeholder.lessons[0].vocabulary)
    }
}
