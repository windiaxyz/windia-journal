import Foundation

@MainActor
final class FriendsViewModel: ObservableObject {
    @Published var friends: [FriendProfile] = []
    @Published var inviteCodeInput = ""
    @Published var myShareCode = ""

    private let service: FriendServicing
    private let userID = UUID()

    init(service: FriendServicing = FriendService()) {
        self.service = service
        self.myShareCode = service.myShareCode(for: userID)
    }

    func loadFriends() async {
        friends = await service.fetchFriends()
    }

    func addFriend() async {
        guard let new = await service.addFriend(inviteCode: inviteCodeInput) else { return }
        friends.insert(new, at: 0)
        inviteCodeInput = ""
    }

    func compatibility(with friend: FriendProfile) -> CompatibilityResult {
        CompatibilityEngine.score(
            userAura: .indigo,
            friendAura: friend.auraArchetype,
            userTraits: PalmTraits(lifeLineDepth: 6, headLineCurve: 7, heartLineLength: 5, openness: 0.7),
            friendTraits: PalmTraits(lifeLineDepth: 5, headLineCurve: 6, heartLineLength: 6, openness: 0.6),
            moodTagsOverlap: 2
        )
    }
}
