import SwiftUI

struct HermosaLessonRow: View {
    let title: String
    let metadata: String
    let progressState: HermosaLessonProgressState

    var body: some View {
        let badge = progressState.badge

        return HStack(alignment: .top, spacing: HermosaMetrics.space12) {
            VStack(alignment: .leading, spacing: HermosaMetrics.space8) {
                Text(title)
                    .hermosaTextStyle(.cardTitle)
                    .foregroundStyle(HermosaColors.textPrimary)

                Text(metadata)
                    .hermosaTextStyle(.secondaryBody)
                    .foregroundStyle(HermosaColors.textSecondary)
            }

            Spacer(minLength: HermosaMetrics.space12)

            HStack(spacing: HermosaMetrics.space8) {
                HermosaProgressBadge(title: badge.title, tone: badge.tone)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .hermosaInteractiveCard()
        .contentShape(RoundedRectangle(cornerRadius: HermosaMetrics.cardCornerRadius, style: .continuous))
    }
}

struct HermosaVocabularyRow: View {
    let word: VocabularyWord

    var body: some View {
        HermosaStudyCard(
            primaryText: word.spanish,
            secondaryText: word.english
        ) {
            Text(word.partOfSpeech)
                .hermosaTextStyle(.metadata)
                .foregroundStyle(HermosaColors.accentSecondary)
                .padding(.horizontal, HermosaMetrics.space8)
                .padding(.vertical, HermosaMetrics.space4)
                .background(
                    Capsule(style: .continuous)
                        .fill(HermosaColors.surfaceStaticMuted)
                )
        }
    }
}

struct HermosaSettingsRow: View {
    let title: String
    var subtitle: String? = nil
    var value: String? = nil

    var body: some View {
        HStack(alignment: .center, spacing: HermosaMetrics.space12) {
            VStack(alignment: .leading, spacing: HermosaMetrics.space4) {
                Text(title)
                    .hermosaTextStyle(.body)
                    .foregroundStyle(HermosaColors.textPrimary)

                if let subtitle, subtitle.isEmpty == false {
                    Text(subtitle)
                        .hermosaTextStyle(.secondaryBody)
                        .foregroundStyle(HermosaColors.textSecondary)
                }
            }

            Spacer(minLength: HermosaMetrics.space12)

            if let value, value.isEmpty == false {
                Text(value)
                    .hermosaTextStyle(.secondaryBody)
                    .foregroundStyle(HermosaColors.textTertiary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .hermosaStaticCard()
        .rowShape()
    }
}

private extension HermosaLessonProgressState {
    var badge: (title: String, tone: HermosaProgressTone) {
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
        contentShape(RoundedRectangle(cornerRadius: HermosaMetrics.cardCornerRadius, style: .continuous))
    }
}
