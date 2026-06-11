import SwiftUI

private struct HermosaCardSurfaceModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    let style: HermosaCardSurfaceStyle

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(HermosaMetrics.cardPadding)
            .background(
                RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
                    .fill(style.fill)
            )
            .overlay {
                RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
                    .stroke(style.stroke, lineWidth: HermosaMetrics.standardBorderWidth)
            }
            .shadow(
                color: style.shadowColor(for: colorScheme),
                radius: style.hasShadow ? HermosaMetrics.shadowRadius : 0,
                x: 0,
                y: style.hasShadow ? HermosaMetrics.shadowY : 0
            )
    }
}

private enum HermosaCardSurfaceStyle: Equatable {
    case staticCard
    case feature
    case interactive(isPressed: Bool)

    var cornerRadius: CGFloat {
        self == .feature ? HermosaMetrics.featureCornerRadius : HermosaMetrics.cardCornerRadius
    }

    var fill: Color {
        switch self {
        case .staticCard: HermosaColors.surfaceStatic
        case .feature: HermosaColors.surfaceFeature
        case let .interactive(isPressed): isPressed ? HermosaColors.surfaceInteractivePressed : HermosaColors.surfaceInteractive
        }
    }

    var stroke: Color {
        switch self {
        case .staticCard, .feature: HermosaColors.strokeSoft
        case let .interactive(isPressed): isPressed ? HermosaColors.strokeInteractivePressed : HermosaColors.strokeInteractive.opacity(0.82)
        }
    }

    var hasShadow: Bool { self == .feature }

    func shadowColor(for colorScheme: ColorScheme) -> Color {
        hasShadow ? HermosaColors.shadow(for: colorScheme) : .clear
    }
}

struct HermosaScreenScrollView<Content: View>: View {
    let isScrollDisabled: Bool
    let content: Content

    init(isScrollDisabled: Bool = false, @ViewBuilder content: () -> Content) {
        self.isScrollDisabled = isScrollDisabled
        self.content = content()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: HermosaMetrics.sectionSpacing) {
                content
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(HermosaMetrics.screenPadding)
        }
        .scrollDisabled(isScrollDisabled)
        .scrollIndicators(.hidden)
        .background(HermosaColors.backgroundBase)
    }
}

struct HermosaScreenSection<Content: View>: View {
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
        VStack(alignment: .leading, spacing: HermosaMetrics.contentSpacing) {
            if title != nil || subtitle != nil {
                HermosaSectionHeader(
                    title: title ?? "",
                    subtitle: subtitle
                )
            }

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct HermosaStackedCardGroup<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: HermosaMetrics.contentSpacing) {
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension View {
    func hermosaStaticCard() -> some View {
        modifier(HermosaCardSurfaceModifier(style: .staticCard))
    }

    func hermosaFeatureCard() -> some View {
        modifier(HermosaCardSurfaceModifier(style: .feature))
    }

    func hermosaInteractiveCard(isPressed: Bool = false) -> some View {
        modifier(HermosaCardSurfaceModifier(style: .interactive(isPressed: isPressed)))
    }
}

#Preview("Surfaces") {
    HermosaScreenScrollView {
        HermosaScreenSection(
            title: "Surface Styles",
            subtitle: "Static, feature, and stacked group containers."
        ) {
            HermosaStackedCardGroup {
                Text("Static card")
                    .hermosaTextStyle(.body)
                    .hermosaStaticCard()

                Text("Feature card")
                    .hermosaTextStyle(.body)
                    .hermosaFeatureCard()

                Text("Interactive card")
                    .hermosaTextStyle(.body)
                    .hermosaInteractiveCard()
            }
        }
    }
}
