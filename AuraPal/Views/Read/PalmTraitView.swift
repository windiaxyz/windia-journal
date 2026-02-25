import SwiftUI

struct PalmTraitView: View {
    let traits: PalmTraits

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Palm Traits")
                .font(.headline)
            Text("Life line depth: \(traits.lifeLineDepth)/10")
            Text("Head line curve: \(traits.headLineCurve)/10")
            Text("Heart line length: \(traits.heartLineLength)/10")
            Text("Energy channels: \(Int(traits.openness * 100))% open")
        }
        .padding()
        .background(Color.orange.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
