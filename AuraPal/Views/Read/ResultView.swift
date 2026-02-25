import SwiftUI

struct ResultView: View {
    let aura: AuraMappingResult
    let palm: PalmTraits?
    let horoscope: HoroscopeResult
    let faceRect: CGRect?

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            AuraGlowView(archetype: aura.archetype, faceRect: faceRect)
                .frame(height: 220)

            Text("Aura: \(aura.archetype.title)")
                .font(.title3.bold())
            Text("Energy score: \(aura.energyScore)")
            Text(aura.interpretation)
                .foregroundStyle(.secondary)

            if let palm {
                PalmTraitView(traits: palm)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Journal prompts")
                    .font(.headline)
                ForEach(aura.prompts, id: \.self) { prompt in
                    Text("• \(prompt)")
                }
            }

            HoroscopeCard(result: horoscope)
        }
        .padding()
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
