import SwiftUI

struct GrammarFocusView: View {
    let items: [String]

    var body: some View {
        HermosaScreenSection(
            title: "Grammar Focus",
            subtitle: "Useful patterns to notice while speaking."
        ) {
            HermosaGrammarCallout(
                title: "What to practice",
                items: items
            )
        }
    }
}

#Preview("Grammar Focus") {
    HermosaScreenScrollView {
        GrammarFocusView(items: Curriculum.placeholder.lessons[0].grammarFocus)
    }
}
