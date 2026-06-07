import SwiftUI

struct GrammarFocusView: View {
    @Environment(\.colorScheme) private var colorScheme
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Grammar Focus")
                .font(.title3.bold())

            ForEach(items, id: \.self) { item in
                Label(item, systemImage: "text.book.closed")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(AppTheme.contentPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius)
                .strokeBorder(AppTheme.edgeGradient(for: colorScheme), lineWidth: 1.1)
        }
    }
}
