import SwiftUI

struct AuroraBackgroundView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        GeometryReader { proxy in
            TimelineView(.animation) { context in
                let phase = reduceMotion ? 0 : context.date.timeIntervalSinceReferenceDate / 18
                let size = proxy.size
                let palette = AppTheme.glowPalette(for: colorScheme)

                ZStack {
                    LinearGradient(
                        colors: AppTheme.baseGradient(for: colorScheme),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    Circle()
                        .fill(RadialGradient(colors: [palette[0], .clear], center: .center, startRadius: 0, endRadius: size.width * 0.48))
                        .frame(width: size.width * 0.95)
                        .offset(
                            x: CGFloat(cos(phase) * size.width * 0.12),
                            y: CGFloat(sin(phase * 0.9) * size.height * 0.08 - size.height * 0.18)
                        )
                        .blur(radius: size.width * 0.08)

                    Circle()
                        .fill(RadialGradient(colors: [palette[1], .clear], center: .center, startRadius: 0, endRadius: size.width * 0.44))
                        .frame(width: size.width * 0.82)
                        .offset(
                            x: CGFloat(sin(phase * 0.8) * size.width * 0.18 + size.width * 0.2),
                            y: CGFloat(cos(phase * 0.7) * size.height * 0.1)
                        )
                        .blur(radius: size.width * 0.08)

                    Circle()
                        .fill(RadialGradient(colors: [palette[2], .clear], center: .center, startRadius: 0, endRadius: size.width * 0.42))
                        .frame(width: size.width * 0.88)
                        .offset(
                            x: CGFloat(cos(phase * 0.65) * size.width * 0.15 - size.width * 0.22),
                            y: CGFloat(sin(phase * 0.75) * size.height * 0.1 + size.height * 0.24)
                        )
                        .blur(radius: size.width * 0.09)

                    Rectangle()
                        .fill(.ultraThinMaterial.opacity(colorScheme == .dark ? 0.12 : 0.22))
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}
