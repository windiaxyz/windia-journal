import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        Form {
            Section("Privacy") {
                Toggle("Share my readings with friends", isOn: $viewModel.shareReadingsWithFriends)
                Toggle("Store optional thumbnails", isOn: $viewModel.storeOptionalThumbnails)
                Text("By default, AuraPal stores only derived reading results on-device.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("Safety") {
                Button("View Disclaimer") { viewModel.showDisclaimer = true }
            }

            Section("Data") {
                Text(viewModel.exportDataJSON())
                    .font(.caption.monospaced())
                Button("Delete account/data", role: .destructive) {
                    viewModel.deleteAllData()
                }
            }
        }
        .navigationTitle("Settings")
        .sheet(isPresented: $viewModel.showDisclaimer) {
            DisclaimerView()
        }
    }
}
