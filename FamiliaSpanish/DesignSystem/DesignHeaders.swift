import SwiftUI

struct FamiliaScreenHeader: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: FamiliaMetrics.space8) {
            Text(title)
                .familiaTextStyle(.screenTitle)
                .foregroundStyle(FamiliaColors.textPrimary)

            if let subtitle, subtitle.isEmpty == false {
                Text(subtitle)
                    .familiaTextStyle(.body)
                    .foregroundStyle(FamiliaColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct FamiliaSectionHeader: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: FamiliaMetrics.space8) {
            Text(title)
                .familiaTextStyle(.sectionTitle)
                .foregroundStyle(FamiliaColors.textPrimary)

            if let subtitle, subtitle.isEmpty == false {
                Text(subtitle)
                    .familiaTextStyle(.secondaryBody)
                    .foregroundStyle(FamiliaColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
