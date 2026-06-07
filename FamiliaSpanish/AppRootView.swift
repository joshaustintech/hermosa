import SwiftUI
import SwiftData

struct AppRootView: View {
    @State private var curriculum: Curriculum?
    @State private var selectedLessonID: String?
    @State private var quizInProgressLessonID: String?
    @State private var loadError: String?
    @Query(sort: \LessonProgress.lessonID) private var lessonProgress: [LessonProgress]

    var body: some View {
        TabView {
            NavigationStack {
                LessonListView(
                    curriculum: curriculum ?? .placeholder,
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
                    curriculum: curriculum ?? .placeholder,
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
        .alert("Lesson Loading Error", isPresented: Binding(
            get: { loadError != nil },
            set: { if !$0 { loadError = nil } }
        )) {
            Button("OK", role: .cancel) {
                loadError = nil
            }
        } message: {
            Text(loadError ?? "")
        }
    }
}

#Preview {
    AppRootView()
        .modelContainer(for: [LessonProgress.self, QuizAttempt.self], inMemory: true)
}
