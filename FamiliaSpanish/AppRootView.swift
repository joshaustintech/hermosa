import SwiftUI
import SwiftData

struct AppRootView: View {
    @State private var curriculum: Curriculum?
    @State private var quizInProgressLessonID: String?
    @State private var loadError: String?
    @Query(sort: \LessonProgress.lessonID) private var lessonProgress: [LessonProgress]

    var body: some View {
        ZStack {
            AuroraBackgroundView()

            Group {
                if let curriculum {
                    TabView {
                        NavigationStack {
                            LessonListView(
                                curriculum: curriculum,
                                lessonProgress: lessonProgress,
                                quizInProgressLessonID: $quizInProgressLessonID
                            )
                            .navigationTitle("Lessons")
                            .navigationBarTitleDisplayMode(.inline)
                        }
                        .tabItem {
                            Label("Lessons", systemImage: "list.bullet.rectangle")
                        }

                        NavigationStack {
                            ProgressViewScreen(
                                curriculum: curriculum,
                                lessonProgress: lessonProgress
                            )
                            .navigationTitle("Progress")
                            .navigationBarTitleDisplayMode(.inline)
                        }
                        .tabItem {
                            Label("Progress", systemImage: "chart.bar")
                        }

                        NavigationStack {
                            SettingsView()
                                .navigationTitle("Settings")
                                .navigationBarTitleDisplayMode(.inline)
                        }
                        .tabItem {
                            Label("Settings", systemImage: "gearshape")
                        }
                    }
                }
                else if let loadError {
                    FamiliaScreenScrollView {
                        FamiliaErrorStateView(
                            title: "Unable to Load Lessons",
                            message: loadError,
                            actionTitle: "Retry",
                            action: loadCurriculum
                        )
                    }
                }
                else {
                    FamiliaScreenScrollView {
                        FamiliaEmptyStateView(
                            title: "Loading Lessons",
                            message: "Bundled lesson content is being prepared.",
                            systemImage: "book.closed"
                        )
                    }
                }
            }
        }
        .tint(FamiliaColors.accentPrimary)
        .toolbarBackground(FamiliaColors.backgroundElevated, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .task {
            guard curriculum == nil, loadError == nil else { return }
            loadCurriculum()
        }
    }

    private func loadCurriculum() {
        do {
            curriculum = try LessonXMLParser.bundledCurriculum()
            loadError = nil
        } catch {
            curriculum = nil
            loadError = error.localizedDescription
        }
    }
}

#Preview {
    AppRootView()
        .modelContainer(for: [LessonProgress.self, QuizAttempt.self], inMemory: true)
}
