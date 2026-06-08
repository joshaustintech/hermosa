import SwiftUI

enum AppTheme {
    static let cardCornerRadius: CGFloat = FamiliaMetrics.featureCornerRadius
    static let innerCornerRadius: CGFloat = FamiliaMetrics.cardCornerRadius
    static let contentPadding: CGFloat = FamiliaMetrics.screenPadding

    static func backgroundColor(for colorScheme: ColorScheme) -> Color {
        FamiliaColors.backgroundBase
    }

    static func edgeGradient(for colorScheme: ColorScheme) -> LinearGradient {
        LinearGradient(
            colors: [
                FamiliaColors.strokeSoft,
                FamiliaColors.strokeStrong.opacity(colorScheme == .dark ? 0.62 : 0.45)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static func strokeColor(for colorScheme: ColorScheme) -> Color {
        FamiliaColors.strokeSoft
    }
}
