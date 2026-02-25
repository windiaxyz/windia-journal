import Foundation
import CloudKit

protocol FriendServicing {
    func fetchFriends() async -> [FriendProfile]
    func addFriend(inviteCode: String) async -> FriendProfile?
    func myShareCode(for userID: UUID) -> String
}

final class FriendService: FriendServicing {
    // TODO: Replace with your CloudKit container identifier and wire entitlements.
    // private let container = CKContainer(identifier: "iCloud.com.yourcompany.AuraPal")

    func fetchFriends() async -> [FriendProfile] {
        // Mock fallback so app runs without CloudKit setup.
        [
            FriendProfile(
                id: UUID(),
                displayName: "Maya",
                avatarSystemName: "person.crop.circle.fill",
                auraArchetype: .purple,
                auraSummary: "Intuitive and steady",
                zodiacSign: "Virgo",
                latestHoroscopeSnippet: "Creative lens is active today.",
                shareCode: "MAYA-1188",
                optInSharedReadings: true
            ),
            FriendProfile(
                id: UUID(),
                displayName: "Noah",
                avatarSystemName: "person.crop.circle.fill",
                auraArchetype: .yellow,
                auraSummary: "Bright social momentum",
                zodiacSign: "Gemini",
                latestHoroscopeSnippet: "Optimism attracts opportunities.",
                shareCode: "NOAH-4421",
                optInSharedReadings: true
            )
        ]
    }

    func addFriend(inviteCode: String) async -> FriendProfile? {
        guard !inviteCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
        return FriendProfile(
            id: UUID(),
            displayName: "New Friend",
            avatarSystemName: "person.crop.circle",
            auraArchetype: .green,
            auraSummary: "Balanced and grounded",
            zodiacSign: nil,
            latestHoroscopeSnippet: "Consistency creates progress.",
            shareCode: inviteCode.uppercased(),
            optInSharedReadings: false
        )
    }

    func myShareCode(for userID: UUID) -> String {
        ("AURA-\(userID.uuidString.prefix(6))").uppercased()
    }
}
