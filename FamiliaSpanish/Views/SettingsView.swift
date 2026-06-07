import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            Section("App") {
                LabeledContent("Version", value: "1.0")
                LabeledContent("Curriculum", value: "1.0")
            }

            Section("Development") {
                Text("Progress reset will be implemented once quiz persistence exists.")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
