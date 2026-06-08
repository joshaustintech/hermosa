import SwiftUI

private struct FamiliaCardSurfaceModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    let style: FamiliaCardSurfaceStyle

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(FamiliaMetrics.cardPadding)
            .background(
                RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
                    .fill(style.fill)
            )
            .overlay {
                RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
                    .stroke(style.stroke, lineWidth: FamiliaMetrics.standardBorderWidth)
            }
            .shadow(
                color: style.shadowColor(for: colorScheme),
                radius: style.hasShadow ? FamiliaMetrics.shadowRadius : 0,
                x: 0,
                y: style.hasShadow ? FamiliaMetrics.shadowY : 0
            )
    }
}

private enum FamiliaCardSurfaceStyle: Equatable {
    case staticCard
    case feature
    case interactive(isPressed: Bool)

    var cornerRadius: CGFloat {
        self == .feature ? FamiliaMetrics.featureCornerRadius : FamiliaMetrics.cardCornerRadius
    }

    var fill: Color {
        switch self {
        case .staticCard: FamiliaColors.surfaceStatic
        case .feature: FamiliaColors.surfaceFeature
        case let .interactive(isPressed): isPressed ? FamiliaColors.surfaceInteractivePressed : FamiliaColors.surfaceInteractive
        }
    }

    var stroke: Color {
        switch self {
        case .staticCard, .feature: FamiliaColors.strokeSoft
        case let .interactive(isPressed): isPressed ? FamiliaColors.strokeInteractivePressed : FamiliaColors.strokeInteractive.opacity(0.82)
        }
    }

    var hasShadow: Bool { self == .feature }

    func shadowColor(for colorScheme: ColorScheme) -> Color {
        hasShadow ? FamiliaColors.shadow(for: colorScheme) : .clear
    }
}

struct FamiliaScreenScrollView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FamiliaMetrics.sectionSpacing) {
                content
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(FamiliaMetrics.screenPadding)
        }
        .scrollIndicators(.hidden)
        .background(FamiliaColors.backgroundBase)
    }
}

struct FamiliaScreenSection<Content: View>: View {
    let title: String?
    let subtitle: String?
    @ViewBuilder let content: Content

    init(
        title: String? = nil,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: FamiliaMetrics.contentSpacing) {
            if title != nil || subtitle != nil {
                FamiliaSectionHeader(
                    title: title ?? "",
                    subtitle: subtitle
                )
            }

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct FamiliaStackedCardGroup<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: FamiliaMetrics.contentSpacing) {
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension View {
    func familiaStaticCard() -> some View {
        modifier(FamiliaCardSurfaceModifier(style: .staticCard))
    }

    func familiaFeatureCard() -> some View {
        modifier(FamiliaCardSurfaceModifier(style: .feature))
    }

    func familiaInteractiveCard(isPressed: Bool = false) -> some View {
        modifier(FamiliaCardSurfaceModifier(style: .interactive(isPressed: isPressed)))
    }
}
