import SwiftUI

struct AuroraBackgroundView: View {
    var body: some View {
        Rectangle()
            .fill(HermosaColors.backgroundBase)
            .overlay(alignment: .top) {
                LinearGradient(
                    colors: [
                        HermosaColors.backgroundElevated.opacity(0.85),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 160)
                .allowsHitTesting(false)
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}

#Preview("Aurora Background") {
    ZStack {
        AuroraBackgroundView()

        HermosaScreenHeader(
            title: "Preview Surface",
            subtitle: "Background treatment for Hermosa screens."
        )
        .padding(HermosaMetrics.screenPadding)
    }
}
