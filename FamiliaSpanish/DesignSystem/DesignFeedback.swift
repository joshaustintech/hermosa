import SwiftUI

struct FamiliaQuizOptionRow: View {
    let title: String
    var state: FamiliaQuizOptionState = .idle
    var action: (() -> Void)? = nil

    var body: some View {
        Group {
            if let action {
                Button(action: action) {
                    optionContent
                }
                .buttonStyle(FamiliaInteractiveRowButtonStyle())
                .disabled(state == .disabled)
            } else {
                optionContent
            }
        }
    }

    private var optionContent: some View {
        HStack(alignment: .top, spacing: FamiliaMetrics.space12) {
            Image(systemName: state.style.symbol)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(state.style.indicator)
                .frame(width: 24, height: 24)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: FamiliaMetrics.space4) {
                Text(title)
                    .familiaTextStyle(state.style.isEmphasized ? .bodyEmphasized : .body)
                    .foregroundStyle(FamiliaColors.textPrimary)
            }

            Spacer(minLength: FamiliaMetrics.space12)
        }
        .padding(FamiliaMetrics.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: FamiliaMetrics.cardCornerRadius, style: .continuous)
                .fill(state.style.background)
        )
        .overlay {
            RoundedRectangle(cornerRadius: FamiliaMetrics.cardCornerRadius, style: .continuous)
                .stroke(state.style.border, lineWidth: FamiliaMetrics.standardBorderWidth)
        }
        .opacity(state == .disabled ? 0.55 : 1)
        .contentShape(RoundedRectangle(cornerRadius: FamiliaMetrics.cardCornerRadius, style: .continuous))
    }
}

struct FamiliaProgressBadge: View {
    let title: String
    let tone: FamiliaProgressTone

    var body: some View {
        Text(title)
            .familiaTextStyle(.metadata)
            .foregroundStyle(tone.foregroundColor)
            .padding(.horizontal, FamiliaMetrics.space8)
            .padding(.vertical, FamiliaMetrics.space4)
            .background(
                Capsule(style: .continuous)
                    .fill(tone.backgroundColor)
            )
    }
}

struct FamiliaProgressBar: View {
    let progress: Double
    let tone: FamiliaProgressTone

    var body: some View {
        GeometryReader { proxy in
            let width = max(0, min(1, progress)) * proxy.size.width

            ZStack(alignment: .leading) {
                Capsule(style: .continuous)
                    .fill(FamiliaColors.backgroundSubtle)

                Capsule(style: .continuous)
                    .fill(tone.barColor)
                    .frame(width: width)
            }
        }
        .frame(height: FamiliaMetrics.progressBarHeight)
        .accessibilityValue(progress.formatted(.percent))
    }
}

struct FamiliaProgressSummaryCard: View {
    let title: String
    let value: String
    let detail: String
    let progress: Double
    let tone: FamiliaProgressTone

    var body: some View {
        VStack(alignment: .leading, spacing: FamiliaMetrics.space12) {
            Text(title)
                .familiaTextStyle(.cardTitle)
                .foregroundStyle(FamiliaColors.textPrimary)

            Text(value)
                .familiaTextStyle(.display)
                .foregroundStyle(FamiliaColors.textPrimary)

            Text(detail)
                .familiaTextStyle(.secondaryBody)
                .foregroundStyle(FamiliaColors.textSecondary)

            FamiliaProgressBar(progress: progress, tone: tone)
        }
        .familiaFeatureCard()
    }
}

struct FamiliaStatusCard: View {
    let title: String
    let message: String
    let systemImage: String
    let imageColor: Color
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: FamiliaMetrics.space16) {
            Image(systemName: systemImage)
                .font(.system(size: 34, weight: .regular))
                .foregroundStyle(imageColor)

            Text(title)
                .familiaTextStyle(.sectionTitle)
                .foregroundStyle(FamiliaColors.textPrimary)
                .multilineTextAlignment(.center)

            Text(message)
                .familiaTextStyle(.body)
                .foregroundStyle(FamiliaColors.textSecondary)
                .multilineTextAlignment(.center)

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(FamiliaPrimaryButtonStyle())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(FamiliaMetrics.space24)
        .familiaFeatureCard()
    }
}

private extension FamiliaProgressTone {
    var foregroundColor: Color {
        switch self {
        case .neutral: FamiliaColors.textSecondary
        case .progress: FamiliaColors.accentPrimary
        case .success: FamiliaColors.success
        }
    }

    var backgroundColor: Color {
        switch self {
        case .neutral: FamiliaColors.backgroundSubtle
        case .progress: FamiliaColors.selectionFill
        case .success: FamiliaColors.success.opacity(0.16)
        }
    }

    var barColor: Color {
        switch self {
        case .neutral: FamiliaColors.strokeStrong
        case .progress: FamiliaColors.accentPrimary
        case .success: FamiliaColors.success
        }
    }
}

private extension FamiliaQuizOptionState {
    var style: (symbol: String, indicator: Color, background: Color, border: Color, isEmphasized: Bool) {
        switch self {
        case .idle, .disabled:
            ("circle", FamiliaColors.textTertiary, FamiliaColors.surfaceInteractive, FamiliaColors.strokeInteractive.opacity(0.75), false)
        case .selected:
            ("largecircle.fill.circle", FamiliaColors.selectionStroke, FamiliaColors.selectionFill, FamiliaColors.selectionStroke, true)
        case .correct:
            ("checkmark.circle.fill", FamiliaColors.success, FamiliaColors.success.opacity(0.18), FamiliaColors.success, true)
        case .incorrect:
            ("xmark.circle.fill", FamiliaColors.error, FamiliaColors.error.opacity(0.16), FamiliaColors.error, false)
        }
    }
}
