import SwiftUI

struct FamiliaPrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .familiaTextStyle(.buttonLabel)
            .foregroundStyle(Color.white.opacity(isEnabled ? 1 : 0.8))
            .frame(maxWidth: .infinity)
            .frame(minHeight: FamiliaMetrics.buttonHeight)
            .padding(.horizontal, FamiliaMetrics.space16)
            .background(
                RoundedRectangle(cornerRadius: FamiliaMetrics.buttonCornerRadius, style: .continuous)
                    .fill(configuration.isPressed ? FamiliaColors.accentPrimaryPressed : FamiliaColors.accentPrimary)
            )
            .opacity(isEnabled ? 1 : 0.55)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct FamiliaInteractiveRowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? FamiliaColors.backgroundSubtle : Color.clear)
            .scaleEffect(configuration.isPressed ? 0.995 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
