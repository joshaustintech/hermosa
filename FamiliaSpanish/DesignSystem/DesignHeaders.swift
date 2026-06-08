import SwiftUI

struct FamiliaScreenHeader: View {
    let title: String
    let subtitle: String?

    init(title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }

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
    let subtitle: String?
    let actionTitle: String?
    let action: (() -> Void)?

    init(
        title: String,
        subtitle: String? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        VStack(alignment: .leading, spacing: FamiliaMetrics.space8) {
            HStack(alignment: .firstTextBaseline, spacing: FamiliaMetrics.space12) {
                Text(title)
                    .familiaTextStyle(.sectionTitle)
                    .foregroundStyle(FamiliaColors.textPrimary)

                Spacer(minLength: FamiliaMetrics.space12)

                if let actionTitle, let action {
                    Button(actionTitle, action: action)
                        .buttonStyle(FamiliaQuietButtonStyle())
                }
            }

            if let subtitle, subtitle.isEmpty == false {
                Text(subtitle)
                    .familiaTextStyle(.secondaryBody)
                    .foregroundStyle(FamiliaColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
