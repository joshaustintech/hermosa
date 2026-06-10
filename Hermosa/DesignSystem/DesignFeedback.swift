import SwiftUI

struct HermosaQuizOptionRow: View {
    let title: String
    var state: HermosaQuizOptionState = .idle
    var action: (() -> Void)? = nil

    var body: some View {
        Group {
            if let action {
                Button(action: action) {
                    optionContent
                }
                .buttonStyle(HermosaInteractiveRowButtonStyle())
                .disabled(state == .disabled)
            } else {
                optionContent
            }
        }
    }

    private var optionContent: some View {
        HStack(alignment: .top, spacing: HermosaMetrics.space12) {
            Image(systemName: state.style.symbol)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(state.style.indicator)
                .frame(width: 24, height: 24)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: HermosaMetrics.space4) {
                Text(title)
                    .hermosaTextStyle(state.style.isEmphasized ? .bodyEmphasized : .body)
                    .foregroundStyle(HermosaColors.textPrimary)
            }

            Spacer(minLength: HermosaMetrics.space12)
        }
        .padding(HermosaMetrics.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: HermosaMetrics.cardCornerRadius, style: .continuous)
                .fill(state.style.background)
        )
        .overlay {
            RoundedRectangle(cornerRadius: HermosaMetrics.cardCornerRadius, style: .continuous)
                .stroke(state.style.border, lineWidth: HermosaMetrics.standardBorderWidth)
        }
        .opacity(state == .disabled ? 0.55 : 1)
        .contentShape(RoundedRectangle(cornerRadius: HermosaMetrics.cardCornerRadius, style: .continuous))
    }
}

struct HermosaProgressBadge: View {
    let title: String
    let tone: HermosaProgressTone

    var body: some View {
        Text(title)
            .hermosaTextStyle(.metadata)
            .foregroundStyle(tone.foregroundColor)
            .padding(.horizontal, HermosaMetrics.space8)
            .padding(.vertical, HermosaMetrics.space4)
            .background(
                Capsule(style: .continuous)
                    .fill(tone.backgroundColor)
            )
    }
}

struct HermosaProgressBar: View {
    let progress: Double
    let tone: HermosaProgressTone

    var body: some View {
        GeometryReader { proxy in
            let width = max(0, min(1, progress)) * proxy.size.width

            ZStack(alignment: .leading) {
                Capsule(style: .continuous)
                    .fill(HermosaColors.backgroundSubtle)

                Capsule(style: .continuous)
                    .fill(tone.barColor)
                    .frame(width: width)
            }
        }
        .frame(height: HermosaMetrics.progressBarHeight)
        .accessibilityValue(progress.formatted(.percent))
    }
}

struct HermosaProgressSummaryCard: View {
    let title: String
    let value: String
    let detail: String
    let progress: Double
    let tone: HermosaProgressTone

    var body: some View {
        VStack(alignment: .leading, spacing: HermosaMetrics.space12) {
            Text(title)
                .hermosaTextStyle(.cardTitle)
                .foregroundStyle(HermosaColors.textPrimary)

            Text(value)
                .hermosaTextStyle(.display)
                .foregroundStyle(HermosaColors.textPrimary)

            Text(detail)
                .hermosaTextStyle(.secondaryBody)
                .foregroundStyle(HermosaColors.textSecondary)

            HermosaProgressBar(progress: progress, tone: tone)
        }
        .hermosaFeatureCard()
    }
}

struct HermosaStatusCard: View {
    let title: String
    let message: String
    let systemImage: String
    let imageColor: Color
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: HermosaMetrics.space16) {
            Image(systemName: systemImage)
                .font(.system(size: 34, weight: .regular))
                .foregroundStyle(imageColor)

            Text(title)
                .hermosaTextStyle(.sectionTitle)
                .foregroundStyle(HermosaColors.textPrimary)
                .multilineTextAlignment(.center)

            Text(message)
                .hermosaTextStyle(.body)
                .foregroundStyle(HermosaColors.textSecondary)
                .multilineTextAlignment(.center)

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(HermosaPrimaryButtonStyle())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(HermosaMetrics.space24)
        .hermosaFeatureCard()
    }
}

private extension HermosaProgressTone {
    var foregroundColor: Color {
        switch self {
        case .neutral: HermosaColors.textSecondary
        case .progress: HermosaColors.accentPrimary
        case .success: HermosaColors.success
        }
    }

    var backgroundColor: Color {
        switch self {
        case .neutral: HermosaColors.backgroundSubtle
        case .progress: HermosaColors.selectionFill
        case .success: HermosaColors.success.opacity(0.16)
        }
    }

    var barColor: Color {
        switch self {
        case .neutral: HermosaColors.strokeStrong
        case .progress: HermosaColors.accentPrimary
        case .success: HermosaColors.success
        }
    }
}

private extension HermosaQuizOptionState {
    var style: (symbol: String, indicator: Color, background: Color, border: Color, isEmphasized: Bool) {
        switch self {
        case .idle, .disabled:
            ("circle", HermosaColors.textTertiary, HermosaColors.surfaceInteractive, HermosaColors.strokeInteractive.opacity(0.75), false)
        case .selected:
            ("largecircle.fill.circle", HermosaColors.selectionStroke, HermosaColors.selectionFill, HermosaColors.selectionStroke, true)
        case .correct:
            ("checkmark.circle.fill", HermosaColors.success, HermosaColors.success.opacity(0.18), HermosaColors.success, true)
        case .incorrect:
            ("xmark.circle.fill", HermosaColors.error, HermosaColors.error.opacity(0.16), HermosaColors.error, false)
        }
    }
}
