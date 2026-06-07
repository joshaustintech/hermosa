import SwiftUI
import SwiftData

struct AppRootView: View {
    @State private var curriculum: Curriculum?
    @State private var selectedLessonID: String?
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
                                selectedLessonID: $selectedLessonID,
                                quizInProgressLessonID: $quizInProgressLessonID
                            )
                            .navigationTitle("Familia Spanish")
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
                        }
                        .tabItem {
                            Label("Progress", systemImage: "chart.bar")
                        }

                        NavigationStack {
                            SettingsView()
                                .navigationTitle("Settings")
                        }
                        .tabItem {
                            Label("Settings", systemImage: "gearshape")
                        }
                    }
                }
                else if let loadError {
                    ContentUnavailableView(
                        "Unable to Load Lessons",
                        systemImage: "exclamationmark.triangle",
                        description: Text(loadError)
                    )
                    .overlay(alignment: .bottom) {
                        Button("Retry", systemImage: "arrow.clockwise", action: loadCurriculum)
                            .buttonStyle(.borderedProminent)
                            .padding()
                    }
                }
                else {
                    ProgressView("Loading Lessons…")
                }
            }
        }
        .toolbarBackground(.thinMaterial, for: .tabBar)
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
