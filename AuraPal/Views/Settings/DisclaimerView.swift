import SwiftUI

struct DisclaimerView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("AuraPal Disclaimer")
                        .font(.title.bold())
                    Text("AuraPal is for entertainment and self-reflection only.")
                    Text("The app does not provide medical, mental health, legal, or financial diagnosis/advice.")
                    Text("Image processing is performed on-device. Raw photos are not uploaded by default.")
                    Text("If you choose sharing features, only derived summaries are shared—not original photos.")
                }
                .padding()
            }
        }
    }
}
