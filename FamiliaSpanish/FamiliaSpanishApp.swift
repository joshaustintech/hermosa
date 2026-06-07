import SwiftUI
import SwiftData

@main
struct FamiliaSpanishApp: App {
    private let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            LessonProgress.self,
            QuizAttempt.self,
        ])

        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
        .modelContainer(sharedModelContainer)
    }
}
