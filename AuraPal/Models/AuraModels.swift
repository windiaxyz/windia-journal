import Foundation
import SwiftData
import SwiftUI

enum AuraArchetype: String, Codable, CaseIterable, Identifiable {
    case blue, green, purple, yellow, orange, red, indigo

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .blue: return .blue
        case .green: return .green
        case .purple: return .purple
        case .yellow: return .yellow
        case .orange: return .orange
        case .red: return .red
        case .indigo: return .indigo
        }
    }

    var title: String { rawValue.capitalized }
}

@Model
final class AuraReading {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var archetypeRaw: String
    var energyScore: Int
    var interpretation: String
    var journalPrompt1: String
    var journalPrompt2: String
    var brightness: Double
    var contrast: Double
    var warmth: Double

    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        archetype: AuraArchetype,
        energyScore: Int,
        interpretation: String,
        journalPrompt1: String,
        journalPrompt2: String,
        brightness: Double,
        contrast: Double,
        warmth: Double
    ) {
        self.id = id
        self.createdAt = createdAt
        self.archetypeRaw = archetype.rawValue
        self.energyScore = energyScore
        self.interpretation = interpretation
        self.journalPrompt1 = journalPrompt1
        self.journalPrompt2 = journalPrompt2
        self.brightness = brightness
        self.contrast = contrast
        self.warmth = warmth
    }

    var archetype: AuraArchetype {
        AuraArchetype(rawValue: archetypeRaw) ?? .blue
    }
}

@Model
final class PalmReading {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var lifeLineDepth: Int
    var headLineCurve: Int
    var heartLineLength: Int
    var openness: Double
    var contrastScore: Double
    var qualityScore: Double

    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        lifeLineDepth: Int,
        headLineCurve: Int,
        heartLineLength: Int,
        openness: Double,
        contrastScore: Double,
        qualityScore: Double
    ) {
        self.id = id
        self.createdAt = createdAt
        self.lifeLineDepth = lifeLineDepth
        self.headLineCurve = headLineCurve
        self.heartLineLength = heartLineLength
        self.openness = openness
        self.contrastScore = contrastScore
        self.qualityScore = qualityScore
    }
}

struct PalmTraits: Codable, Equatable {
    let lifeLineDepth: Int
    let headLineCurve: Int
    let heartLineLength: Int
    let openness: Double
}

@Model
final class DailyProfile {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var summary: String
    var luckyColor: String
    var focusTheme: String
    var doText: String
    var dontText: String

    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        summary: String,
        luckyColor: String,
        focusTheme: String,
        doText: String,
        dontText: String
    ) {
        self.id = id
        self.createdAt = createdAt
        self.summary = summary
        self.luckyColor = luckyColor
        self.focusTheme = focusTheme
        self.doText = doText
        self.dontText = dontText
    }
}

@Model
final class UserProfile {
    @Attribute(.unique) var id: UUID
    var displayName: String
    var avatarSystemName: String
    var archetypeRaw: String
    var auraSummary: String
    var zodiacSign: String?
    var shareReadingsWithFriends: Bool
    var storeOptionalThumbnails: Bool

    init(
        id: UUID = UUID(),
        displayName: String,
        avatarSystemName: String = "person.crop.circle.fill",
        archetype: AuraArchetype,
        auraSummary: String,
        zodiacSign: String? = nil,
        shareReadingsWithFriends: Bool = false,
        storeOptionalThumbnails: Bool = false
    ) {
        self.id = id
        self.displayName = displayName
        self.avatarSystemName = avatarSystemName
        self.archetypeRaw = archetype.rawValue
        self.auraSummary = auraSummary
        self.zodiacSign = zodiacSign
        self.shareReadingsWithFriends = shareReadingsWithFriends
        self.storeOptionalThumbnails = storeOptionalThumbnails
    }

    var archetype: AuraArchetype {
        AuraArchetype(rawValue: archetypeRaw) ?? .indigo
    }
}

struct FriendProfile: Identifiable, Codable {
    let id: UUID
    var displayName: String
    var avatarSystemName: String
    var auraArchetype: AuraArchetype
    var auraSummary: String
    var zodiacSign: String?
    var latestHoroscopeSnippet: String
    var shareCode: String
    var optInSharedReadings: Bool
}
