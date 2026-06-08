import SwiftUI

enum FamiliaTextRole {
    case display
    case screenTitle
    case sectionTitle
    case cardTitle
    case body
    case bodyEmphasized
    case secondaryBody
    case metadata
    case caption
    case buttonLabel

    var font: Font {
        switch self {
        case .display:
            return .system(size: 34, weight: .semibold, design: .serif)
        case .screenTitle:
            return .system(size: 28, weight: .semibold, design: .serif)
        case .sectionTitle:
            return .system(size: 22, weight: .medium, design: .serif)
        case .cardTitle:
            return .system(size: 20, weight: .medium, design: .serif)
        case .body:
            return .system(size: 17, weight: .regular, design: .default)
        case .bodyEmphasized:
            return .system(size: 17, weight: .semibold, design: .default)
        case .secondaryBody:
            return .system(size: 15, weight: .regular, design: .default)
        case .metadata:
            return .system(size: 13, weight: .medium, design: .default)
        case .caption:
            return .system(size: 12, weight: .regular, design: .default)
        case .buttonLabel:
            return .system(size: 17, weight: .semibold, design: .default)
        }
    }
}

enum FamiliaTypography {
    static let display = FamiliaTextRole.display.font
    static let screenTitle = FamiliaTextRole.screenTitle.font
    static let sectionTitle = FamiliaTextRole.sectionTitle.font
    static let cardTitle = FamiliaTextRole.cardTitle.font
    static let body = FamiliaTextRole.body.font
    static let bodyEmphasized = FamiliaTextRole.bodyEmphasized.font
    static let secondaryBody = FamiliaTextRole.secondaryBody.font
    static let metadata = FamiliaTextRole.metadata.font
    static let caption = FamiliaTextRole.caption.font
    static let buttonLabel = FamiliaTextRole.buttonLabel.font
}

extension View {
    func familiaTextStyle(_ role: FamiliaTextRole) -> some View {
        font(role.font)
            .dynamicTypeSize(.small ... .accessibility3)
    }
}
