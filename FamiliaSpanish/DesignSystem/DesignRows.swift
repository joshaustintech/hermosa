import SwiftUI

struct FamiliaLessonRow: View {
    let title: String
    let metadata: String
    let progressState: FamiliaLessonProgressState

    var body: some View {
        let badge = progressState.badge

        return HStack(alignment: .top, spacing: FamiliaMetrics.space12) {
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
                FamiliaProgressBadge(title: badge.title, tone: badge.tone)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .familiaInteractiveCard()
        .contentShape(RoundedRectangle(cornerRadius: FamiliaMetrics.cardCornerRadius, style: .continuous))
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
    var subtitle: String? = nil
    var value: String? = nil

    var body: some View {
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
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .familiaStaticCard()
        .rowShape()
    }
}

private extension FamiliaLessonProgressState {
    var badge: (title: String, tone: FamiliaProgressTone) {
        switch self {
        case .notStarted: ("Not Started", .neutral)
        case let .inProgress(score): (score.title(prefix: "Best") ?? "In Progress", .progress)
        case let .completed(score): (score.title(prefix: "Done") ?? "Done", .success)
        }
    }
}

private extension Optional where Wrapped == Double {
    func title(prefix: String) -> String? {
        guard let self, self > 0 else { return nil }
        return "\(prefix) \(self.formatted(.percent.precision(.fractionLength(0))))"
    }
}

private extension View {
    func rowShape() -> some View {
        contentShape(RoundedRectangle(cornerRadius: FamiliaMetrics.cardCornerRadius, style: .continuous))
    }
}
