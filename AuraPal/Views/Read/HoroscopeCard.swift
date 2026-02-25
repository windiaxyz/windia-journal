import SwiftUI

struct HoroscopeCard: View {
    let result: HoroscopeResult

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Daily Horoscope")
                .font(.headline)
            Text(result.message)
            Divider().overlay(.white.opacity(0.3))
            Text("Lucky color: \(result.luckyColor)")
            Text("Focus theme: \(result.focusTheme)")
            Text("Do: \(result.doText)")
            Text("Don’t: \(result.dontText)")
        }
        .font(.subheadline)
        .padding()
        .background(LinearGradient(colors: [.purple.opacity(0.35), .blue.opacity(0.25)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
