import Foundation

struct CompatibilityResult: Equatable {
    let score: Int
    let bestTogetherFor: String
    let potentialFriction: String
}

enum CompatibilityEngine {
    static func score(
        userAura: AuraArchetype,
        friendAura: AuraArchetype,
        userTraits: PalmTraits?,
        friendTraits: PalmTraits?,
        moodTagsOverlap: Int
    ) -> CompatibilityResult {
        let auraDistance = abs(userAuraIndex(userAura) - userAuraIndex(friendAura))
        let auraComponent = max(0, 45 - auraDistance * 6)

        let traitsComponent: Int = {
            guard let u = userTraits, let f = friendTraits else { return 20 }
            let life = max(0, 15 - abs(u.lifeLineDepth - f.lifeLineDepth) * 2)
            let head = max(0, 12 - abs(u.headLineCurve - f.headLineCurve) * 2)
            let heart = max(0, 12 - abs(u.heartLineLength - f.heartLineLength) * 2)
            return life + head + heart
        }()

        let moodComponent = min(20, moodTagsOverlap * 5)
        let final = min(100, auraComponent + traitsComponent + moodComponent)

        let best = final > 75 ? "Creative projects and emotional support" : "Light social plans and check-ins"
        let friction = final > 60 ? "Over-planning" : "Communication timing and mixed pacing"
        return CompatibilityResult(score: final, bestTogetherFor: best, potentialFriction: friction)
    }

    static func userAuraIndex(_ aura: AuraArchetype) -> Int {
        AuraArchetype.allCases.firstIndex(of: aura) ?? 0
    }
}
