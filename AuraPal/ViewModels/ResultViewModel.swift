import Foundation
import SwiftData

@MainActor
final class ResultViewModel: ObservableObject {
    func save(
        aura: AuraMappingResult,
        palm: PalmTraits?,
        horoscope: HoroscopeResult,
        context: ModelContext
    ) {
        let auraReading = AuraReading(
            archetype: aura.archetype,
            energyScore: aura.energyScore,
            interpretation: aura.interpretation,
            journalPrompt1: aura.prompts.first ?? "",
            journalPrompt2: aura.prompts.dropFirst().first ?? "",
            brightness: 0.5,
            contrast: 0.5,
            warmth: 0.0
        )
        context.insert(auraReading)

        if let palm {
            context.insert(PalmReading(
                lifeLineDepth: palm.lifeLineDepth,
                headLineCurve: palm.headLineCurve,
                heartLineLength: palm.heartLineLength,
                openness: palm.openness,
                contrastScore: 0.5,
                qualityScore: palm.openness
            ))
        }

        context.insert(DailyProfile(
            summary: horoscope.message,
            luckyColor: horoscope.luckyColor,
            focusTheme: horoscope.focusTheme,
            doText: horoscope.doText,
            dontText: horoscope.dontText
        ))

        try? context.save()
    }
}
