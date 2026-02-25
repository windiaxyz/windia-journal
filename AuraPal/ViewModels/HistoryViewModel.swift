import Foundation
import SwiftData

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published var selectedAuraFilter: AuraArchetype?

    func filter(readings: [AuraReading]) -> [AuraReading] {
        guard let selectedAuraFilter else { return readings }
        return readings.filter { $0.archetype == selectedAuraFilter }
    }
}
