import SwiftUI

struct ScanProgressView: View {
    @State private var animate = false

    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Scanning your aura signature…")
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(colors: [.purple, .blue, .pink], startPoint: .leading, endPoint: .trailing)
                )
                .frame(height: 6)
                .opacity(animate ? 1 : 0.2)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: animate)
        }
        .padding()
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear { animate = true }
    }
}
