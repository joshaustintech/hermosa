import SwiftUI

struct SettingsView: View {
    var body: some View {
        HermosaScreenScrollView {
            HermosaScreenHeader(
                title: "Settings",
                subtitle: "Version details and future maintenance actions live here."
            )

            HermosaScreenSection(title: "App") {
                HermosaStackedCardGroup {
                    HermosaSettingsRow(title: "Version", value: "1.0")
                    HermosaSettingsRow(title: "Curriculum", value: "1.0")
                }
            }

            HermosaScreenSection(
                title: "Development",
                subtitle: "Settings actions will expand as progress management lands."
            ) {
                HermosaStaticInfoCard {
                    Text("Progress reset will be implemented once quiz persistence exists.")
                        .hermosaTextStyle(.body)
                        .foregroundStyle(HermosaColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .background(HermosaColors.backgroundBase)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { SettingsView() }
    }
}
