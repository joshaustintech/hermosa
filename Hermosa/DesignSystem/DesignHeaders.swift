import SwiftUI

struct HermosaScreenHeader: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: HermosaMetrics.space8) {
            Text(title)
                .hermosaTextStyle(.screenTitle)
                .foregroundStyle(HermosaColors.textPrimary)

            if let subtitle, subtitle.isEmpty == false {
                Text(subtitle)
                    .hermosaTextStyle(.body)
                    .foregroundStyle(HermosaColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct HermosaSectionHeader: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: HermosaMetrics.space8) {
            Text(title)
                .hermosaTextStyle(.sectionTitle)
                .foregroundStyle(HermosaColors.textPrimary)

            if let subtitle, subtitle.isEmpty == false {
                Text(subtitle)
                    .hermosaTextStyle(.secondaryBody)
                    .foregroundStyle(HermosaColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("Headers") {
    HermosaScreenScrollView {
        VStack(alignment: .leading, spacing: HermosaMetrics.sectionSpacing) {
            HermosaScreenHeader(
                title: "Lessons",
                subtitle: "Study practical Spanish through calm, readable lesson sets."
            )

            HermosaSectionHeader(
                title: "Vocabulary",
                subtitle: "High-frequency words tied to this lesson."
            )
        }
    }
}
