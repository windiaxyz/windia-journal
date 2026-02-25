import Foundation

struct HoroscopeResult: Equatable {
    let message: String
    let luckyColor: String
    let focusTheme: String
    let doText: String
    let dontText: String
    let snippet: String
}

protocol HoroscopeServicing {
    func generate(
        userID: UUID,
        date: Date,
        aura: AuraArchetype,
        palmTraits: PalmTraits?,
        zodiac: String?
    ) -> HoroscopeResult
}

final class HoroscopeService: HoroscopeServicing {
    func generate(userID: UUID, date: Date, aura: AuraArchetype, palmTraits: PalmTraits?, zodiac: String?) -> HoroscopeResult {
        HoroscopeTemplates.generate(userID: userID, date: date, aura: aura, palmTraits: palmTraits, zodiac: zodiac)
    }
}

enum HoroscopeTemplates {
    static func generate(userID: UUID, date: Date, aura: AuraArchetype, palmTraits: PalmTraits?, zodiac: String?) -> HoroscopeResult {
        let seed = deterministicSeed(userID: userID, date: date)
        var generator = SeededRandomNumberGenerator(seed: seed)

        let themes = ["Connection", "Focus", "Creativity", "Rest", "Momentum", "Patience"]
        let dos = ["Finish one meaningful task", "Reach out to one trusted person", "Take a short mindful break", "Write down one brave idea"]
        let donts = ["Overcommit", "Skip hydration and movement", "Revisit old arguments", "Ignore your natural pace"]

        let auraLine = auraMessages[aura]?.randomElement(using: &generator) ?? "Today favors balance and perspective."
        let traitLine = traitMessage(from: palmTraits)
        let zodiacLine = zodiac.map { "Zodiac nudge for \($0): trust steady progress." } ?? ""

        let luckyColor = luckyColors[aura]?.randomElement(using: &generator) ?? "Silver"
        let focusTheme = themes.randomElement(using: &generator) ?? "Focus"
        let doText = dos.randomElement(using: &generator) ?? "Take one clear next step"
        let dontText = donts.randomElement(using: &generator) ?? "Rush big decisions"

        let message = [auraLine, traitLine, zodiacLine].filter { !$0.isEmpty }.joined(separator: " ")
        let snippet = String(message.prefix(90))

        return HoroscopeResult(message: message, luckyColor: luckyColor, focusTheme: focusTheme, doText: doText, dontText: dontText, snippet: snippet)
    }

    static func deterministicSeed(userID: UUID, date: Date) -> UInt64 {
        let day = Calendar.current.startOfDay(for: date).timeIntervalSince1970
        return UInt64(abs(userID.uuidString.hashValue ^ Int(day)))
    }

    static func traitMessage(from traits: PalmTraits?) -> String {
        guard let t = traits else {
            return "Palm insight: keep your plans simple and grounded."
        }

        if t.openness > 0.7 {
            return "Palm insight: open energy channels support collaboration today."
        } else if t.lifeLineDepth > 7 {
            return "Palm insight: deep reserves suggest endurance for long tasks."
        } else if t.headLineCurve > 6 {
            return "Palm insight: flexible thinking helps with unexpected turns."
        } else {
            return "Palm insight: steady pacing wins over intensity."
        }
    }

    private static let auraMessages: [AuraArchetype: [String]] = [
        .blue: ["Blue aura day: clear communication unlocks support.", "Blue aura day: reflection leads to practical insight."],
        .green: ["Green aura day: restore first, then build momentum.", "Green aura day: consistency creates progress."],
        .purple: ["Purple aura day: intuition pairs well with planning.", "Purple aura day: your creative lens is especially active."],
        .yellow: ["Yellow aura day: optimism attracts opportunities.", "Yellow aura day: joy fuels productive action."],
        .orange: ["Orange aura day: confidence helps you start boldly.", "Orange aura day: playful experiments may pay off."],
        .red: ["Red aura day: focused action brings visible results.", "Red aura day: courage works best with patience."],
        .indigo: ["Indigo aura day: deep focus reveals hidden patterns.", "Indigo aura day: protect quiet time for your best thinking."]
    ]

    private static let luckyColors: [AuraArchetype: [String]] = [
        .blue: ["Sky Blue", "Slate"], .green: ["Sage", "Emerald"], .purple: ["Violet", "Plum"],
        .yellow: ["Gold", "Sunbeam"], .orange: ["Coral", "Apricot"], .red: ["Ruby", "Brick"], .indigo: ["Midnight", "Iris"]
    ]
}

struct SeededRandomNumberGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        self.state = seed == 0 ? 0x12345678 : seed
    }

    mutating func next() -> UInt64 {
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return state
    }
}
