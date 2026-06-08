import SwiftUI

struct FamiliaLessonRow: View {
    let title: String
    let metadata: String
    let progressState: FamiliaLessonProgressState
    let action: (() -> Void)?

    init(
        title: String,
        metadata: String,
        progressState: FamiliaLessonProgressState,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.metadata = metadata
        self.progressState = progressState
        self.action = action
    }

    var body: some View {
        Group {
            if let action {
                Button(action: action) {
                    rowContent
                }
                .buttonStyle(FamiliaInteractiveRowButtonStyle())
            } else {
                rowContent
            }
        }
    }

    private var rowContent: some View {
        HStack(alignment: .top, spacing: FamiliaMetrics.space12) {
            VStack(alignment: .leading, spacing: FamiliaMetrics.space8) {
                Text(title)
                    .familiaTextStyle(.cardTitle)
                    .foregroundStyle(FamiliaColors.textPrimary)

                Text(metadata)
                    .familiaTextStyle(.secondaryBody)
                    .foregroundStyle(FamiliaColors.textSecondary)
            }

            Spacer(minLength: FamiliaMetrics.space12)

            HStack(spacing: FamiliaMetrics.space8) {
                badge

                if action != nil {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(FamiliaColors.accentPrimary)
                        .accessibilityHidden(true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .familiaInteractiveCard()
        .contentShape(RoundedRectangle(cornerRadius: FamiliaMetrics.cardCornerRadius, style: .continuous))
    }

    @ViewBuilder
    private var badge: some View {
        switch progressState {
        case .notStarted:
            FamiliaProgressBadge(title: "Not Started", tone: .neutral)
        case let .inProgress(bestScore):
            if let bestScore, bestScore > 0 {
                FamiliaProgressBadge(
                    title: "Best \(bestScore.formatted(.percent.precision(.fractionLength(0))))",
                    tone: .progress
                )
            } else {
                FamiliaProgressBadge(title: "In Progress", tone: .progress)
            }
        case let .completed(bestScore):
            if let bestScore, bestScore > 0 {
                FamiliaProgressBadge(
                    title: "Done \(bestScore.formatted(.percent.precision(.fractionLength(0))))",
                    tone: .success
                )
            } else {
                FamiliaProgressBadge(title: "Done", tone: .success)
            }
        }
    }
}

struct FamiliaVocabularyRow: View {
    let word: VocabularyWord

    var body: some View {
        FamiliaStudyCard(
            primaryText: word.spanish,
            secondaryText: word.english
        ) {
            Text(word.partOfSpeech)
                .familiaTextStyle(.metadata)
                .foregroundStyle(FamiliaColors.accentSecondary)
                .padding(.horizontal, FamiliaMetrics.space8)
                .padding(.vertical, FamiliaMetrics.space4)
                .background(
                    Capsule(style: .continuous)
                        .fill(FamiliaColors.surfaceStaticMuted)
                )
        }
    }
}

struct FamiliaSettingsRow: View {
    let title: String
    let subtitle: String?
    let value: String?
    let isInteractive: Bool
    let action: (() -> Void)?

    init(
        title: String,
        subtitle: String? = nil,
        value: String? = nil,
        isInteractive: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.value = value
        self.isInteractive = isInteractive
        self.action = action
    }

    var body: some View {
        Group {
            if let action, isInteractive {
                Button(action: action) {
                    rowContent
                }
                .buttonStyle(FamiliaInteractiveRowButtonStyle())
            } else {
                rowContent
            }
        }
    }

    @ViewBuilder
    private var rowContent: some View {
        if isInteractive {
            rowBase
                .familiaInteractiveCard()
                .contentShape(RoundedRectangle(cornerRadius: FamiliaMetrics.cardCornerRadius, style: .continuous))
        } else {
            rowBase
                .familiaStaticCard()
                .contentShape(RoundedRectangle(cornerRadius: FamiliaMetrics.cardCornerRadius, style: .continuous))
        }
    }

    private var rowBase: some View {
        HStack(alignment: .center, spacing: FamiliaMetrics.space12) {
            VStack(alignment: .leading, spacing: FamiliaMetrics.space4) {
                Text(title)
                    .familiaTextStyle(.body)
                    .foregroundStyle(FamiliaColors.textPrimary)

                if let subtitle, subtitle.isEmpty == false {
                    Text(subtitle)
                        .familiaTextStyle(.secondaryBody)
                        .foregroundStyle(FamiliaColors.textSecondary)
                }
            }

            Spacer(minLength: FamiliaMetrics.space12)

            if let value, value.isEmpty == false {
                Text(value)
                    .familiaTextStyle(.secondaryBody)
                    .foregroundStyle(FamiliaColors.textTertiary)
            }

            if isInteractive {
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(FamiliaColors.accentPrimary)
                    .accessibilityHidden(true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
