import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var shareReadingsWithFriends = false
    @Published var storeOptionalThumbnails = false
    @Published var showDisclaimer = false

    func exportDataJSON() -> String {
        """
        {
          "exportedAt": "\(ISO8601DateFormatter().string(from: .now))",
          "note": "Entertainment-only derived AuraPal data export."
        }
        """
    }

    func deleteAllData() {
        // TODO: Connect to SwiftData deletion + CloudKit account cleanup if enabled.
    }
}
