import SwiftUI

struct ReadingDetailView: View {
    let reading: AuraReading

    var body: some View {
        Form {
            Section("Aura") {
                Text(reading.archetype.title)
                Text("Energy score: \(reading.energyScore)")
                Text(reading.interpretation)
            }

            Section("Journal") {
                Text(reading.journalPrompt1)
                Text(reading.journalPrompt2)
            }

            Section("Derived Metrics") {
                Text("Brightness: \(reading.brightness, format: .number.precision(.fractionLength(2)))")
                Text("Contrast: \(reading.contrast, format: .number.precision(.fractionLength(2)))")
                Text("Warmth: \(reading.warmth, format: .number.precision(.fractionLength(2)))")
            }
        }
        .navigationTitle("Reading")
    }
}
