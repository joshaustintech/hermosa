import SwiftUI
import UIKit

extension Color {
    fileprivate init(hermosaHex hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b, a: UInt64
        switch hex.count {
        case 8:
            (r, g, b, a) = (
                (int >> 24) & 0xff,
                (int >> 16) & 0xff,
                (int >> 8) & 0xff,
                int & 0xff
            )
        default:
            (r, g, b, a) = (
                (int >> 16) & 0xff,
                (int >> 8) & 0xff,
                int & 0xff,
                0xff
            )
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    fileprivate static func hermosaDynamic(light: String, dark: String) -> Color {
        Color(
            uiColor: UIColor { traitCollection in
                let hex = traitCollection.userInterfaceStyle == .dark ? dark : light
                return UIColor(Color(hermosaHex: hex))
            }
        )
    }
}

enum HermosaColors {
    static let backgroundBase = Color.hermosaDynamic(light: "#FFFFFF", dark: "#08101C")
    static let backgroundElevated = Color.hermosaDynamic(light: "#F8FBFF", dark: "#0D1626")
    static let backgroundSubtle = Color.hermosaDynamic(light: "#F3F4F6", dark: "#122033")

    static let surfaceStatic = Color.hermosaDynamic(light: "#FFFFFF", dark: "#101B2C")
    static let surfaceStaticMuted = Color.hermosaDynamic(light: "#F3F4F6", dark: "#142133")
    static let surfaceInteractive = Color.hermosaDynamic(light: "#F9FBFF", dark: "#172538")
    static let surfaceInteractivePressed = Color.hermosaDynamic(light: "#EDF4FF", dark: "#1B2D45")
    static let surfaceFeature = Color.hermosaDynamic(light: "#F6FAFF", dark: "#122238")

    static let strokeSoft = Color.hermosaDynamic(light: "#D7DCE2", dark: "#2A3B54")
    static let strokeStrong = Color.hermosaDynamic(light: "#B8C3D1", dark: "#3B5275")
    static let strokeInteractive = Color.hermosaDynamic(light: "#005FD6", dark: "#4CA3E8")
    static let strokeInteractivePressed = Color.hermosaDynamic(light: "#0B2F6B", dark: "#7DAFE8")
    static let divider = Color.hermosaDynamic(light: "#D7DCE2", dark: "#24344B")

    static let textPrimary = Color.hermosaDynamic(light: "#111111", dark: "#F6F9FE")
    static let textSecondary = Color.hermosaDynamic(light: "#4E5B6B", dark: "#C5D2E3")
    static let textTertiary = Color.hermosaDynamic(light: "#6B7280", dark: "#95A5BC")

    static let accentPrimary = Color.hermosaDynamic(light: "#005FD6", dark: "#4CA3E8")
    static let accentPrimaryPressed = Color.hermosaDynamic(light: "#0B2F6B", dark: "#7DAFE8")
    static let accentSecondary = Color.hermosaDynamic(light: "#1F5FAE", dark: "#7DAFE8")
    static let accentSecondaryPressed = Color.hermosaDynamic(light: "#0B2F6B", dark: "#4CA3E8")

    static let success = Color.hermosaDynamic(light: "#7AC943", dark: "#9DDF6D")
    static let error = Color.hermosaDynamic(light: "#FF7A1A", dark: "#FF9A4F")

    static let selectionFill = Color.hermosaDynamic(light: "#DDEBFF", dark: "#173359")
    static let selectionStroke = Color.hermosaDynamic(light: "#005FD6", dark: "#7DAFE8")

    static let shadowLight = Color(hermosaHex: "#0B2F6B14")
    static let shadowDark = Color(hermosaHex: "#00000040")

    static func shadow(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? shadowDark : shadowLight
    }
}
