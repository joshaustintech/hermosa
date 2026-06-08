import SwiftUI

struct AuroraBackgroundView: View {
    var body: some View {
        Rectangle()
            .fill(FamiliaColors.backgroundBase)
            .overlay(alignment: .top) {
                LinearGradient(
                    colors: [
                        FamiliaColors.backgroundElevated.opacity(0.85),
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
