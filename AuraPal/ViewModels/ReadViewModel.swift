import Foundation
import SwiftUI

@MainActor
final class ReadViewModel: ObservableObject {
    enum ScanMode: String, CaseIterable, Identifiable {
        case selfieAura = "Selfie Aura"
        case palmScan = "Palm Scan"

        var id: String { rawValue }
    }

    @Published var selectedMode: ScanMode = .selfieAura
    @Published var selectedImage: UIImage?
    @Published var quickMoodTags: Set<String> = []
    @Published var isScanning = false
    @Published var latestAura: AuraMappingResult?
    @Published var latestPalm: PalmTraits?
    @Published var latestHoroscope: HoroscopeResult?
    @Published var faceRect: CGRect?
    @Published var palmQuality: Double = 0
    @Published var showGuidedPalmQuestions = false
    @Published var guidedAnswers = (5, 5, 5)

    private let imageService: ImageAnalysisServicing
    private let visionService: VisionServicing
    private let horoscopeService: HoroscopeServicing

    init(
        imageService: ImageAnalysisServicing = ImageAnalysisService(),
        visionService: VisionServicing = VisionService(),
        horoscopeService: HoroscopeServicing = HoroscopeService()
    ) {
        self.imageService = imageService
        self.visionService = visionService
        self.horoscopeService = horoscopeService
    }

    func revealReading(userID: UUID = UUID(), zodiac: String? = nil) async {
        guard let image = selectedImage else { return }
        isScanning = true
        try? await Task.sleep(for: .seconds(1.4))

        let metrics = imageService.analyze(image: image)
        let aura = imageService.mapMetricsToAura(metrics)
        latestAura = aura

        if selectedMode == .selfieAura {
            faceRect = visionService.detectFace(in: image).faceRect
            latestPalm = nil
        } else {
            let hand = visionService.detectHandPose(in: image)
            palmQuality = metrics.contrast
            if hand.detected {
                latestPalm = PalmTraits(
                    lifeLineDepth: Int((metrics.contrast * 10).rounded()),
                    headLineCurve: Int((hand.fingerSpread * 10).rounded()),
                    heartLineLength: Int((metrics.brightness * 10).rounded()),
                    openness: hand.openness
                )
            } else {
                showGuidedPalmQuestions = true
                latestPalm = PalmTraits(
                    lifeLineDepth: guidedAnswers.0,
                    headLineCurve: guidedAnswers.1,
                    heartLineLength: guidedAnswers.2,
                    openness: max(0.2, metrics.contrast)
                )
            }
        }

        latestHoroscope = horoscopeService.generate(
            userID: userID,
            date: .now,
            aura: aura.archetype,
            palmTraits: latestPalm,
            zodiac: zodiac
        )
        isScanning = false
    }
}
