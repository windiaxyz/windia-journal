import SwiftUI

struct AddFriendView: View {
    @ObservedObject var viewModel: FriendsViewModel

    var body: some View {
        Form {
            TextField("Invite code", text: $viewModel.inviteCodeInput)
                .textInputAutocapitalization(.characters)

            Button("Add") {
                Task { await viewModel.addFriend() }
            }
        }
        .navigationTitle("Add Friend")
    }
}
