import SwiftUI

struct FamiliaQuizOptionRow: View {
    let title: String
    let detail: String?
    let state: FamiliaQuizOptionState
    let action: (() -> Void)?

    init(
        title: String,
        detail: String? = nil,
        state: FamiliaQuizOptionState = .idle,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.detail = detail
        self.state = state
        self.action = action
    }

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
            Image(systemName: indicatorSymbol)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(indicatorColor)
                .frame(width: 24, height: 24)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: FamiliaMetrics.space4) {
                Text(title)
                    .familiaTextStyle(state == .selected || state == .correct ? .bodyEmphasized : .body)
                    .foregroundStyle(FamiliaColors.textPrimary)

                if let detail, detail.isEmpty == false {
                    Text(detail)
                        .familiaTextStyle(.secondaryBody)
                        .foregroundStyle(FamiliaColors.textSecondary)
                }
            }

            Spacer(minLength: FamiliaMetrics.space12)
        }
        .padding(FamiliaMetrics.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: FamiliaMetrics.cardCornerRadius, style: .continuous)
                .fill(backgroundColor)
        )
        .overlay {
            RoundedRectangle(cornerRadius: FamiliaMetrics.cardCornerRadius, style: .continuous)
                .stroke(borderColor, lineWidth: FamiliaMetrics.standardBorderWidth)
        }
        .opacity(state == .disabled ? 0.55 : 1)
        .contentShape(RoundedRectangle(cornerRadius: FamiliaMetrics.cardCornerRadius, style: .continuous))
    }

    private var indicatorSymbol: String {
        switch state {
        case .idle, .disabled:
            return "circle"
        case .selected:
            return "largecircle.fill.circle"
        case .correct:
            return "checkmark.circle.fill"
        case .incorrect:
            return "xmark.circle.fill"
        }
    }

    private var indicatorColor: Color {
        switch state {
        case .idle, .disabled:
            return FamiliaColors.textTertiary
        case .selected:
            return FamiliaColors.selectionStroke
        case .correct:
            return FamiliaColors.success
        case .incorrect:
            return FamiliaColors.error
        }
    }

    private var backgroundColor: Color {
        switch state {
        case .idle, .disabled:
            return FamiliaColors.surfaceInteractive
        case .selected:
            return FamiliaColors.selectionFill
        case .correct:
            return FamiliaColors.success.opacity(0.18)
        case .incorrect:
            return FamiliaColors.error.opacity(0.16)
        }
    }

    private var borderColor: Color {
        switch state {
        case .idle, .disabled:
            return FamiliaColors.strokeInteractive.opacity(0.75)
        case .selected:
            return FamiliaColors.selectionStroke
        case .correct:
            return FamiliaColors.success
        case .incorrect:
            return FamiliaColors.error
        }
    }
}

struct FamiliaProgressBadge: View {
    let title: String
    let tone: FamiliaProgressTone

    var body: some View {
        Text(title)
            .familiaTextStyle(.metadata)
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, FamiliaMetrics.space8)
            .padding(.vertical, FamiliaMetrics.space4)
            .background(
                Capsule(style: .continuous)
                    .fill(backgroundColor)
            )
    }

    private var foregroundColor: Color {
        switch tone {
        case .neutral:
            return FamiliaColors.textSecondary
        case .progress:
            return FamiliaColors.accentPrimary
        case .success:
            return FamiliaColors.success
        case .warning:
            return FamiliaColors.warning
        case .error:
            return FamiliaColors.error
        }
    }

    private var backgroundColor: Color {
        switch tone {
        case .neutral:
            return FamiliaColors.backgroundSubtle
        case .progress:
            return FamiliaColors.selectionFill
        case .success:
            return FamiliaColors.success.opacity(0.16)
        case .warning:
            return FamiliaColors.warning.opacity(0.16)
        case .error:
            return FamiliaColors.error.opacity(0.14)
        }
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
                    .fill(fillColor)
                    .frame(width: width)
            }
        }
        .frame(height: FamiliaMetrics.progressBarHeight)
        .accessibilityValue(progress.formatted(.percent))
    }

    private var fillColor: Color {
        switch tone {
        case .neutral:
            return FamiliaColors.strokeStrong
        case .progress:
            return FamiliaColors.accentPrimary
        case .success:
            return FamiliaColors.success
        case .warning:
            return FamiliaColors.warning
        case .error:
            return FamiliaColors.error
        }
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

struct FamiliaEmptyStateView: View {
    let title: String
    let message: String
    let systemImage: String
    let actionTitle: String?
    let action: (() -> Void)?

    init(
        title: String,
        message: String,
        systemImage: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.systemImage = systemImage
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        VStack(spacing: FamiliaMetrics.space16) {
            Image(systemName: systemImage)
                .font(.system(size: 34, weight: .regular))
                .foregroundStyle(FamiliaColors.accentSecondary)

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

struct FamiliaErrorStateView: View {
    let title: String
    let message: String
    let actionTitle: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: FamiliaMetrics.space16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 34, weight: .regular))
                .foregroundStyle(FamiliaColors.error)

            Text(title)
                .familiaTextStyle(.sectionTitle)
                .foregroundStyle(FamiliaColors.textPrimary)
                .multilineTextAlignment(.center)

            Text(message)
                .familiaTextStyle(.body)
                .foregroundStyle(FamiliaColors.textSecondary)
                .multilineTextAlignment(.center)

            Button(actionTitle, action: action)
                .buttonStyle(FamiliaPrimaryButtonStyle())
        }
        .frame(maxWidth: .infinity)
        .padding(FamiliaMetrics.space24)
        .familiaFeatureCard()
    }
}
