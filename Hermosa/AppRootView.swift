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
                        appTab("Lessons", systemImage: "list.bullet.rectangle") {
                            LessonListView(
                                curriculum: curriculum,
                                lessonProgress: lessonProgress,
                                quizInProgressLessonID: $quizInProgressLessonID
                            )
                        }

                        appTab("Progress", systemImage: "chart.bar") {
                            ProgressViewScreen(
                                curriculum: curriculum,
                                lessonProgress: lessonProgress
                            )
                        }

                        appTab("Settings", systemImage: "gearshape") {
                            SettingsView()
                        }
                    }
                }
                else if let loadError {
                    HermosaScreenScrollView {
                        HermosaStatusCard(
                            title: "Unable to Load Lessons",
                            message: loadError,
                            systemImage: "exclamationmark.triangle",
                            imageColor: HermosaColors.error,
                            actionTitle: "Retry",
                            action: loadCurriculum
                        )
                    }
                }
                else {
                    HermosaScreenScrollView {
                        HermosaStatusCard(
                            title: "Loading Lessons",
                            message: "Bundled lesson content is being prepared.",
                            systemImage: "book.closed",
                            imageColor: HermosaColors.accentSecondary
                        )
                    }
                }
            }
        }
        .tint(HermosaColors.accentPrimary)
        .toolbarBackground(HermosaColors.backgroundElevated, for: .tabBar)
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

    private func appTab<Content: View>(
        _ title: String,
        systemImage: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationStack {
            content()
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        }
        .tabItem { Label(title, systemImage: systemImage) }
    }
}

struct AppRootView_Previews: PreviewProvider {
    static var previews: some View {
        AppRootView()
            .modelContainer(for: [LessonProgress.self, QuizAttempt.self], inMemory: true)
    }
}
