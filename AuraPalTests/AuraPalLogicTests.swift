import XCTest
@testable import AuraPal

final class AuraPalLogicTests: XCTestCase {
    func testAuraMappingDeterministic() {
        let metrics = ImageMetrics(brightness: 0.75, contrast: 0.20, warmth: 0.10, dominantRGB: (0.8, 0.7, 0.6))
        let first = AuraHeuristics.map(metrics: metrics)
        let second = AuraHeuristics.map(metrics: metrics)
        XCTAssertEqual(first, second)
    }

    func testHoroscopeSeededDeterministic() {
        let userID = UUID(uuidString: "AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEEE")!
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let traits = PalmTraits(lifeLineDepth: 4, headLineCurve: 5, heartLineLength: 6, openness: 0.8)

        let one = HoroscopeTemplates.generate(userID: userID, date: date, aura: .green, palmTraits: traits, zodiac: "Aries")
        let two = HoroscopeTemplates.generate(userID: userID, date: date, aura: .green, palmTraits: traits, zodiac: "Aries")

        XCTAssertEqual(one, two)
    }

    func testCompatibilityRange() {
        let result = CompatibilityEngine.score(
            userAura: .blue,
            friendAura: .red,
            userTraits: PalmTraits(lifeLineDepth: 6, headLineCurve: 6, heartLineLength: 6, openness: 0.5),
            friendTraits: PalmTraits(lifeLineDepth: 6, headLineCurve: 6, heartLineLength: 6, openness: 0.5),
            moodTagsOverlap: 2
        )
        XCTAssertTrue((0...100).contains(result.score))
    }
}
