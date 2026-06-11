import SwiftUI
import SwiftData

struct SettingsView: View {
    let curriculum: Curriculum

    @Environment(\.modelContext) private var modelContext
    @State private var showingResetConfirmation = false

    var body: some View {
        HermosaScreenScrollView {
            HermosaScreenHeader(
                title: "Settings",
                subtitle: "Version details and maintenance actions live here."
            )

            HermosaScreenSection(title: "App Info") {
                HermosaStackedCardGroup {
                    HermosaSettingsRow(title: "App Version", value: "1.0")
                    HermosaSettingsRow(title: "Curriculum Version", value: curriculum.version)
                }
            }

            HermosaScreenSection(
                title: "Development",
                subtitle: "Manage local app state and progress records."
            ) {
                HermosaStackedCardGroup {
                    Button(role: .destructive) {
                        showingResetConfirmation = true
                    } label: {
                        HStack {
                            Text("Reset Progress")
                                .hermosaTextStyle(.bodyEmphasized)
                                .foregroundStyle(HermosaColors.error)
                            Spacer()
                            Image(systemName: "trash")
                                .foregroundStyle(HermosaColors.error)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .hermosaInteractiveCard()
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Reset Progress")
                    .accessibilityHint("Deletes all lesson progress and quiz attempts after confirmation.")
                }
            }
        }
        .background(HermosaColors.backgroundBase)
        .confirmationDialog(
            "Are you sure you want to reset all progress?",
            isPresented: $showingResetConfirmation,
            titleVisibility: .visible
        ) {
            Button("Reset Progress", role: .destructive) {
                resetProgress()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete all lesson progress records and quiz attempts. This action cannot be undone.")
        }
    }

    private func resetProgress() {
        do {
            try modelContext.delete(model: LessonProgress.self)
            try modelContext.delete(model: QuizAttempt.self)
            try modelContext.save()
        } catch {
            let progressDescriptor = FetchDescriptor<LessonProgress>()
            if let progressList = try? modelContext.fetch(progressDescriptor) {
                for progress in progressList {
                    modelContext.delete(progress)
                }
            }
            let attemptDescriptor = FetchDescriptor<QuizAttempt>()
            if let attemptList = try? modelContext.fetch(attemptDescriptor) {
                for attempt in attemptList {
                    modelContext.delete(attempt)
                }
            }
            try? modelContext.save()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(curriculum: .placeholder)
        }
        .modelContainer(for: [LessonProgress.self, QuizAttempt.self], inMemory: true)
    }
}
