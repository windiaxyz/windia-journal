import SwiftUI

struct FriendsListView: View {
    @ObservedObject var viewModel: FriendsViewModel

    var body: some View {
        List {
            Section("Add Friend") {
                NavigationLink("Enter Invite Code") {
                    AddFriendView(viewModel: viewModel)
                }
                LabeledContent("My Share Code", value: viewModel.myShareCode)
                    .textSelection(.enabled)
            }

            Section("Friends") {
                ForEach(viewModel.friends) { friend in
                    NavigationLink {
                        FriendDetailView(friend: friend, compatibility: viewModel.compatibility(with: friend))
                    } label: {
                        HStack {
                            Image(systemName: friend.avatarSystemName)
                            VStack(alignment: .leading) {
                                Text(friend.displayName)
                                Text(friend.latestHoroscopeSnippet)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(friend.auraArchetype.title)
                                .font(.caption.bold())
                                .padding(6)
                                .background(friend.auraArchetype.color.opacity(0.25))
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }
        .navigationTitle("Friends")
    }
}
