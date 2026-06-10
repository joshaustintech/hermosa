import SwiftUI

enum HermosaTextRole {
    case display
    case screenTitle
    case sectionTitle
    case cardTitle
    case body
    case bodyEmphasized
    case secondaryBody
    case metadata
    case buttonLabel

    var font: Font {
        switch self {
        case .display: .system(size: 34, weight: .semibold, design: .serif)
        case .screenTitle: .system(size: 28, weight: .semibold, design: .serif)
        case .sectionTitle: .system(size: 22, weight: .medium, design: .serif)
        case .cardTitle: .system(size: 20, weight: .medium, design: .serif)
        case .body: .system(size: 17, weight: .regular, design: .default)
        case .bodyEmphasized, .buttonLabel: .system(size: 17, weight: .semibold, design: .default)
        case .secondaryBody: .system(size: 15, weight: .regular, design: .default)
        case .metadata: .system(size: 13, weight: .medium, design: .default)
        }
    }
}

extension View {
    func hermosaTextStyle(_ role: HermosaTextRole) -> some View {
        font(role.font)
            .dynamicTypeSize(.small ... .accessibility3)
    }
}
