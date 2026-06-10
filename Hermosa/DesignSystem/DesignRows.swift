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

struct HermosaNavigationRow: View {
    let title: String
    let subtitle: String
    let badge: String
    let systemImage: String

    var body: some View {
        HStack(alignment: .top, spacing: HermosaMetrics.space12) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(HermosaColors.accentPrimary)
                .frame(width: 32, height: 32)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(HermosaColors.selectionFill)
                )

            VStack(alignment: .leading, spacing: HermosaMetrics.space8) {
                Text(title)
                    .hermosaTextStyle(.bodyEmphasized)
                    .foregroundStyle(HermosaColors.textPrimary)

                Text(subtitle)
                    .hermosaTextStyle(.secondaryBody)
                    .foregroundStyle(HermosaColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: HermosaMetrics.space12)

            VStack(alignment: .trailing, spacing: HermosaMetrics.space8) {
                Text(badge)
                    .hermosaTextStyle(.metadata)
                    .foregroundStyle(HermosaColors.accentSecondary)
                    .padding(.horizontal, HermosaMetrics.space8)
                    .padding(.vertical, HermosaMetrics.space4)
                    .background(
                        Capsule(style: .continuous)
                            .fill(HermosaColors.surfaceStaticMuted)
                    )

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(HermosaColors.textTertiary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .hermosaInteractiveCard()
        .contentShape(RoundedRectangle(cornerRadius: HermosaMetrics.cardCornerRadius, style: .continuous))
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

#Preview("Rows") {
    HermosaScreenScrollView {
        VStack(alignment: .leading, spacing: HermosaMetrics.sectionSpacing) {
            HermosaLessonRow(
                title: Curriculum.placeholder.lessons[0].title,
                metadata: "Beginner • 20 min",
                progressState: .completed(bestScore: 1)
            )

            HermosaVocabularyRow(word: Curriculum.placeholder.lessons[0].vocabulary[0])

            HermosaSettingsRow(
                title: "Reset Progress",
                subtitle: "Clear quiz attempts and lesson completion.",
                value: "Off"
            )

            HermosaNavigationRow(
                title: "Vocabulary Deck",
                subtitle: "Spanish on the front, English and part of speech on the back.",
                badge: "10 cards",
                systemImage: "rectangle.stack"
            )
        }
    }
}
