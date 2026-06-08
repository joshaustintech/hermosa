import SwiftUI

struct GrammarFocusView: View {
    let items: [String]

    var body: some View {
        FamiliaScreenSection(
            title: "Grammar Focus",
            subtitle: "Useful patterns to notice while speaking."
        ) {
            FamiliaGrammarCallout(
                title: "What to practice",
                items: items
            )
        }
    }
}
