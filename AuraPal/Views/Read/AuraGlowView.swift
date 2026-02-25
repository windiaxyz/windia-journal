import SwiftUI

struct AuraGlowView: View {
    let archetype: AuraArchetype
    let faceRect: CGRect?

    var body: some View {
        GeometryReader { geo in
            let center = mappedCenter(in: geo.size)

            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.black.opacity(0.35))

                RadialGradient(
                    gradient: Gradient(colors: [archetype.color.opacity(0.7), archetype.color.opacity(0.25), .clear]),
                    center: .init(x: center.x / geo.size.width, y: center.y / geo.size.height),
                    startRadius: 12,
                    endRadius: 130
                )
                .blur(radius: 8)

                Circle()
                    .stroke(archetype.color.opacity(0.8), lineWidth: 4)
                    .frame(width: 130, height: 130)
                    .position(center)
                    .blur(radius: 0.7)
            }
        }
        .accessibilityLabel("Aura glow visualization")
    }

    private func mappedCenter(in size: CGSize) -> CGPoint {
        guard let faceRect else { return CGPoint(x: size.width / 2, y: size.height / 2) }
        let x = faceRect.midX * size.width
        let y = (1 - faceRect.midY) * size.height
        return CGPoint(x: x, y: y)
    }
}
