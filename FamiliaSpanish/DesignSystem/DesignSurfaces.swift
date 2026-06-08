import SwiftUI

struct FamiliaStaticCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(FamiliaMetrics.cardPadding)
            .background(
                RoundedRectangle(cornerRadius: FamiliaMetrics.cardCornerRadius, style: .continuous)
                    .fill(FamiliaColors.surfaceStatic)
            )
            .overlay {
                RoundedRectangle(cornerRadius: FamiliaMetrics.cardCornerRadius, style: .continuous)
                    .stroke(FamiliaColors.strokeSoft, lineWidth: FamiliaMetrics.standardBorderWidth)
            }
    }
}

struct FamiliaFeatureCardModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(FamiliaMetrics.cardPadding)
            .background(
                RoundedRectangle(cornerRadius: FamiliaMetrics.featureCornerRadius, style: .continuous)
                    .fill(FamiliaColors.surfaceFeature)
            )
            .overlay {
                RoundedRectangle(cornerRadius: FamiliaMetrics.featureCornerRadius, style: .continuous)
                    .stroke(FamiliaColors.strokeSoft, lineWidth: FamiliaMetrics.standardBorderWidth)
            }
            .shadow(
                color: FamiliaColors.shadow(for: colorScheme),
                radius: FamiliaMetrics.shadowRadius,
                x: 0,
                y: FamiliaMetrics.shadowY
            )
    }
}

struct FamiliaInteractiveCardModifier: ViewModifier {
    let isPressed: Bool

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(FamiliaMetrics.cardPadding)
            .background(
                RoundedRectangle(cornerRadius: FamiliaMetrics.cardCornerRadius, style: .continuous)
                    .fill(isPressed ? FamiliaColors.surfaceInteractivePressed : FamiliaColors.surfaceInteractive)
            )
            .overlay {
                RoundedRectangle(cornerRadius: FamiliaMetrics.cardCornerRadius, style: .continuous)
                    .stroke(
                        isPressed ? FamiliaColors.strokeInteractivePressed : FamiliaColors.strokeInteractive.opacity(0.82),
                        lineWidth: FamiliaMetrics.standardBorderWidth
                    )
            }
    }
}

struct FamiliaInputSurfaceModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, FamiliaMetrics.space16)
            .padding(.vertical, FamiliaMetrics.space12)
            .background(
                RoundedRectangle(cornerRadius: FamiliaMetrics.smallCornerRadius, style: .continuous)
                    .fill(FamiliaColors.surfaceInput)
            )
            .overlay {
                RoundedRectangle(cornerRadius: FamiliaMetrics.smallCornerRadius, style: .continuous)
                    .stroke(FamiliaColors.strokeSoft, lineWidth: FamiliaMetrics.standardBorderWidth)
            }
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
    let content: Content

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
        modifier(FamiliaStaticCardModifier())
    }

    func familiaFeatureCard() -> some View {
        modifier(FamiliaFeatureCardModifier())
    }

    func familiaInputSurface() -> some View {
        modifier(FamiliaInputSurfaceModifier())
    }

    func familiaInteractiveCard(isPressed: Bool = false) -> some View {
        modifier(FamiliaInteractiveCardModifier(isPressed: isPressed))
    }
}
