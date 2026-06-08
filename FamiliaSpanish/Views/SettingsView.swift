import SwiftUI

struct SettingsView: View {
    var body: some View {
        FamiliaScreenScrollView {
            FamiliaScreenHeader(
                title: "Settings",
                subtitle: "Version details and future maintenance actions live here."
            )

            FamiliaScreenSection(title: "App") {
                FamiliaStackedCardGroup {
                    FamiliaSettingsRow(title: "Version", value: "1.0")
                    FamiliaSettingsRow(title: "Curriculum", value: "1.0")
                }
            }

            FamiliaScreenSection(
                title: "Development",
                subtitle: "Settings actions will expand as progress management lands."
            ) {
                FamiliaStaticInfoCard {
                    Text("Progress reset will be implemented once quiz persistence exists.")
                        .familiaTextStyle(.body)
                        .foregroundStyle(FamiliaColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .background(FamiliaColors.backgroundBase)
    }
}

#Preview { NavigationStack { SettingsView() } }
