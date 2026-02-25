import SwiftUI

struct RootTabView: View {
    @StateObject private var readVM = ReadViewModel()
    @StateObject private var friendsVM = FriendsViewModel()
    @StateObject private var historyVM = HistoryViewModel()
    @StateObject private var settingsVM = SettingsViewModel()

    var body: some View {
        TabView {
            NavigationStack {
                ReadHomeView(viewModel: readVM)
            }
            .tabItem { Label("Read", systemImage: "sparkles") }

            NavigationStack {
                FriendsListView(viewModel: friendsVM)
            }
            .tabItem { Label("Friends", systemImage: "person.2") }

            NavigationStack {
                HistoryListView(viewModel: historyVM)
            }
            .tabItem { Label("History", systemImage: "clock.arrow.circlepath") }

            NavigationStack {
                SettingsView(viewModel: settingsVM)
            }
            .tabItem { Label("Settings", systemImage: "gearshape") }
        }
        .preferredColorScheme(.dark)
        .tint(.purple)
        .background(
            LinearGradient(
                colors: [.black, Color.purple.opacity(0.2), Color.blue.opacity(0.15)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .task {
            await friendsVM.loadFriends()
        }
    }
}
