import SwiftUI

enum AppTheme {
    static let cardCornerRadius: CGFloat = 24
    static let innerCornerRadius: CGFloat = 18
    static let contentPadding: CGFloat = 20

    static func backgroundColor(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return Color(red: 0.03, green: 0.04, blue: 0.06)
        default:
            return Color(red: 0.95, green: 0.96, blue: 0.98)
        }
    }

    static func edgeGradient(for colorScheme: ColorScheme) -> LinearGradient {
        switch colorScheme {
        case .dark:
            return LinearGradient(
                colors: [
                    Color(red: 0.24, green: 0.68, blue: 0.75).opacity(0.7),
                    Color.white.opacity(0.08),
                    Color(red: 0.92, green: 0.56, blue: 0.28).opacity(0.45)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                colors: [
                    Color(red: 0.24, green: 0.62, blue: 0.72).opacity(0.6),
                    Color.white.opacity(0.6),
                    Color(red: 0.93, green: 0.63, blue: 0.28).opacity(0.55)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    static func strokeColor(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return .white.opacity(0.14)
        default:
            return .white.opacity(0.72)
        }
    }
}
