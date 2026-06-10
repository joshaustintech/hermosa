import SwiftUI

struct HermosaPrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .hermosaTextStyle(.buttonLabel)
            .foregroundStyle(Color.white.opacity(isEnabled ? 1 : 0.8))
            .frame(maxWidth: .infinity)
            .frame(minHeight: HermosaMetrics.buttonHeight)
            .padding(.horizontal, HermosaMetrics.space16)
            .background(
                RoundedRectangle(cornerRadius: HermosaMetrics.buttonCornerRadius, style: .continuous)
                    .fill(configuration.isPressed ? HermosaColors.accentPrimaryPressed : HermosaColors.accentPrimary)
            )
            .opacity(isEnabled ? 1 : 0.55)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct HermosaInteractiveRowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? HermosaColors.backgroundSubtle : Color.clear)
            .scaleEffect(configuration.isPressed ? 0.995 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
