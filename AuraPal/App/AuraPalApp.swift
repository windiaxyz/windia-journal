import SwiftUI
import SwiftData

@main
struct AuraPalApp: App {
    private let container: ModelContainer = {
        let schema = Schema([
            AuraReading.self,
            PalmReading.self,
            DailyProfile.self,
            UserProfile.self
        ])

        do {
            return try ModelContainer(for: schema)
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(container)
    }
}
