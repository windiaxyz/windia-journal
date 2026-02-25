import SwiftUI

struct FriendDetailView: View {
    let friend: FriendProfile
    let compatibility: CompatibilityResult

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: friend.avatarSystemName)
                    .font(.largeTitle)
                VStack(alignment: .leading) {
                    Text(friend.displayName).font(.title2.bold())
                    Text(friend.auraSummary).foregroundStyle(.secondary)
                }
            }

            Text("Latest aura: \(friend.auraArchetype.title)")
            Text("Horoscope: \(friend.latestHoroscopeSnippet)")

            VStack(alignment: .leading, spacing: 6) {
                Text("Compatibility: \(compatibility.score)%").font(.headline)
                Text("Best together for: \(compatibility.bestTogetherFor)")
                Text("Potential friction: \(compatibility.potentialFriction)")
            }
            .padding()
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Spacer()
        }
        .padding()
        .navigationTitle("Friend Detail")
    }
}
