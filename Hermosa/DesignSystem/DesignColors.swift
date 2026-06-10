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
    static let backgroundBase = Color.hermosaDynamic(light: "#F4F0EA", dark: "#161315")
    static let backgroundElevated = Color.hermosaDynamic(light: "#FCF8F2", dark: "#1E1A1D")
    static let backgroundSubtle = Color.hermosaDynamic(light: "#E8E1D8", dark: "#292427")

    static let surfaceStatic = Color.hermosaDynamic(light: "#F1E8DD", dark: "#262124")
    static let surfaceStaticMuted = Color.hermosaDynamic(light: "#ECE3D8", dark: "#221D20")
    static let surfaceInteractive = Color.hermosaDynamic(light: "#FAF5EF", dark: "#30282C")
    static let surfaceInteractivePressed = Color.hermosaDynamic(light: "#F3E7E6", dark: "#3A3035")
    static let surfaceFeature = Color.hermosaDynamic(light: "#FFF9F4", dark: "#231E21")

    static let strokeSoft = Color.hermosaDynamic(light: "#CFC4B8", dark: "#4A4144")
    static let strokeStrong = Color.hermosaDynamic(light: "#A99788", dark: "#6A5D63")
    static let strokeInteractive = Color.hermosaDynamic(light: "#8C3B4A", dark: "#C56A78")
    static let strokeInteractivePressed = Color.hermosaDynamic(light: "#6F2D39", dark: "#9E5360")
    static let divider = Color.hermosaDynamic(light: "#D7CDC2", dark: "#3A3337")

    static let textPrimary = Color.hermosaDynamic(light: "#221A1C", dark: "#F6EDEE")
    static let textSecondary = Color.hermosaDynamic(light: "#5B4F52", dark: "#D6C7CB")
    static let textTertiary = Color.hermosaDynamic(light: "#85767A", dark: "#AA999F")

    static let accentPrimary = Color.hermosaDynamic(light: "#8C3B4A", dark: "#C56A78")
    static let accentPrimaryPressed = Color.hermosaDynamic(light: "#6F2D39", dark: "#9E5360")
    static let accentSecondary = Color.hermosaDynamic(light: "#2F6D67", dark: "#79AAA4")
    static let accentSecondaryPressed = Color.hermosaDynamic(light: "#245650", dark: "#5D8882")

    static let success = Color.hermosaDynamic(light: "#5A7353", dark: "#90AD87")
    static let error = Color.hermosaDynamic(light: "#A1463F", dark: "#D97E77")

    static let selectionFill = Color.hermosaDynamic(light: "#EAD6DB", dark: "#4B2C35")
    static let selectionStroke = Color.hermosaDynamic(light: "#8C3B4A", dark: "#C56A78")

    static let shadowLight = Color(hermosaHex: "#00000014")
    static let shadowDark = Color(hermosaHex: "#00000033")

    static func shadow(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? shadowDark : shadowLight
    }
}
