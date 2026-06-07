import SwiftUI

enum AppTheme {
    static let cardCornerRadius: CGFloat = 24
    static let innerCornerRadius: CGFloat = 18
    static let contentPadding: CGFloat = 20

    static func baseGradient(for colorScheme: ColorScheme) -> [Color] {
        switch colorScheme {
        case .dark:
            return [
                Color(red: 0.05, green: 0.08, blue: 0.14),
                Color(red: 0.09, green: 0.14, blue: 0.22),
                Color(red: 0.16, green: 0.09, blue: 0.18)
            ]
        default:
            return [
                Color(red: 0.97, green: 0.98, blue: 1.0),
                Color(red: 0.99, green: 0.96, blue: 0.91),
                Color(red: 0.92, green: 0.96, blue: 0.96)
            ]
        }
    }

    static func glowPalette(for colorScheme: ColorScheme) -> [Color] {
        switch colorScheme {
        case .dark:
            return [
                Color(red: 0.22, green: 0.69, blue: 0.74).opacity(0.48),
                Color(red: 0.30, green: 0.47, blue: 0.94).opacity(0.34),
                Color(red: 0.94, green: 0.55, blue: 0.27).opacity(0.24)
            ]
        default:
            return [
                Color(red: 0.46, green: 0.77, blue: 0.82).opacity(0.34),
                Color(red: 0.98, green: 0.73, blue: 0.45).opacity(0.24),
                Color(red: 0.96, green: 0.56, blue: 0.61).opacity(0.18)
            ]
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
