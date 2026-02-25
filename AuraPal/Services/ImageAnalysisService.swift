import Foundation
import UIKit
import CoreImage

struct ImageMetrics: Equatable {
    let brightness: Double
    let contrast: Double
    let warmth: Double
    let dominantRGB: (Double, Double, Double)
}

struct AuraMappingResult: Equatable {
    let archetype: AuraArchetype
    let energyScore: Int
    let interpretation: String
    let prompts: [String]
}

protocol ImageAnalysisServicing {
    func analyze(image: UIImage) -> ImageMetrics
    func mapMetricsToAura(_ metrics: ImageMetrics) -> AuraMappingResult
}

final class ImageAnalysisService: ImageAnalysisServicing {
    private let context = CIContext()

    func analyze(image: UIImage) -> ImageMetrics {
        guard let ciImage = CIImage(image: image) else {
            return ImageMetrics(brightness: 0.5, contrast: 0.5, warmth: 0.0, dominantRGB: (0.5, 0.5, 0.5))
        }

        let avg = averageColor(ciImage: ciImage)
        let brightness = (avg.r + avg.g + avg.b) / 3
        let maxC = max(avg.r, max(avg.g, avg.b))
        let minC = min(avg.r, min(avg.g, avg.b))
        let contrast = maxC - minC
        let warmth = avg.r - avg.b

        return ImageMetrics(brightness: brightness, contrast: contrast, warmth: warmth, dominantRGB: (avg.r, avg.g, avg.b))
    }

    func mapMetricsToAura(_ metrics: ImageMetrics) -> AuraMappingResult {
        AuraHeuristics.map(metrics: metrics)
    }

    private func averageColor(ciImage: CIImage) -> (r: Double, g: Double, b: Double) {
        let extent = ciImage.extent
        let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: ciImage, kCIInputExtentKey: CIVector(cgRect: extent)])
        guard
            let output = filter?.outputImage
        else { return (0.5, 0.5, 0.5) }

        var bitmap = [UInt8](repeating: 0, count: 4)
        context.render(output, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())

        return (Double(bitmap[0]) / 255, Double(bitmap[1]) / 255, Double(bitmap[2]) / 255)
    }
}

enum AuraHeuristics {
    static func map(metrics: ImageMetrics) -> AuraMappingResult {
        let archetype: AuraArchetype
        switch (metrics.warmth, metrics.brightness, metrics.contrast) {
        case let (w, b, c) where w > 0.25 && b > 0.6:
            archetype = .orange
        case let (w, _, c) where w > 0.18 && c > 0.28:
            archetype = .red
        case let (w, b, _) where w > 0.05 && b > 0.7:
            archetype = .yellow
        case let (w, b, c) where w < -0.2 && c > 0.25:
            archetype = .indigo
        case let (w, b, _) where w < -0.12 && b < 0.45:
            archetype = .blue
        case let (_, b, c) where b < 0.38 && c < 0.15:
            archetype = .purple
        default:
            archetype = .green
        }

        let scoreRaw = Int((metrics.brightness * 45) + (metrics.contrast * 35) + ((1 - abs(metrics.warmth)) * 20))
        let energy = min(100, max(1, scoreRaw))

        let interpretation = interpretationFor(archetype: archetype, energy: energy)
        let prompts = promptsFor(archetype: archetype)

        return AuraMappingResult(archetype: archetype, energyScore: energy, interpretation: interpretation, prompts: prompts)
    }

    private static func interpretationFor(archetype: AuraArchetype, energy: Int) -> String {
        switch archetype {
        case .blue: return "Calm and thoughtful energy. Your pace today supports clarity and meaningful conversations. Energy: \(energy)."
        case .green: return "Balanced and restorative energy. You’re in a good zone for steady progress. Energy: \(energy)."
        case .purple: return "Reflective and intuitive energy. Prioritize quiet focus and creative ideas. Energy: \(energy)."
        case .yellow: return "Bright and optimistic energy. Great for social momentum and quick wins. Energy: \(energy)."
        case .orange: return "Expressive and playful energy. Lean into confidence and experimentation. Energy: \(energy)."
        case .red: return "Bold and action-oriented energy. Channel intensity into one clear priority. Energy: \(energy)."
        case .indigo: return "Deep and analytical energy. You may notice patterns others miss. Energy: \(energy)."
        }
    }

    private static func promptsFor(archetype: AuraArchetype) -> [String] {
        switch archetype {
        case .blue:
            return ["Where can I choose calm over urgency today?", "What conversation needs clearer boundaries?"]
        case .green:
            return ["What routine is helping me most right now?", "Where can I simplify and recover energy?"]
        case .purple:
            return ["What intuition have I been ignoring?", "Which creative thought deserves 20 minutes?"]
        case .yellow:
            return ["What can I celebrate right now?", "How can I share my enthusiasm constructively?"]
        case .orange:
            return ["Where can I take a playful risk?", "What is one authentic way to show up today?"]
        case .red:
            return ["What single action will move me forward most?", "How do I protect energy from burnout?"]
        case .indigo:
            return ["What pattern am I noticing repeatedly?", "What does deep focus look like for me today?"]
        }
    }
}
