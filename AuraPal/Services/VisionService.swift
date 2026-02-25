import Foundation
import Vision
import UIKit

struct FaceDetectionResult {
    let faceRect: CGRect?
}

struct HandPoseResult {
    let detected: Bool
    let openness: Double
    let fingerSpread: Double
}

protocol VisionServicing {
    func detectFace(in image: UIImage) -> FaceDetectionResult
    func detectHandPose(in image: UIImage) -> HandPoseResult
}

final class VisionService: VisionServicing {
    func detectFace(in image: UIImage) -> FaceDetectionResult {
        guard let cgImage = image.cgImage else { return .init(faceRect: nil) }

        let request = VNDetectFaceRectanglesRequest()
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
            let rect = (request.results?.first as? VNFaceObservation)?.boundingBox
            return FaceDetectionResult(faceRect: rect)
        } catch {
            return FaceDetectionResult(faceRect: nil)
        }
    }

    func detectHandPose(in image: UIImage) -> HandPoseResult {
        guard let cgImage = image.cgImage else { return .init(detected: false, openness: 0.5, fingerSpread: 0.5) }

        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = 1
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        do {
            try handler.perform([request])
            guard let observation = request.results?.first else {
                return .init(detected: false, openness: 0.5, fingerSpread: 0.5)
            }

            let points = try observation.recognizedPoints(.all)
            let wrist = points[.wrist]
            let indexTip = points[.indexTip]
            let littleTip = points[.littleTip]
            let middleMCP = points[.middleMCP]

            let spread = normalizedDistance(indexTip, littleTip)
            let openness = normalizedDistance(wrist, middleMCP)
            return .init(detected: true, openness: openness, fingerSpread: spread)
        } catch {
            return .init(detected: false, openness: 0.5, fingerSpread: 0.5)
        }
    }

    private func normalizedDistance(_ p1: VNRecognizedPoint?, _ p2: VNRecognizedPoint?) -> Double {
        guard let p1, let p2, p1.confidence > 0.2, p2.confidence > 0.2 else { return 0.5 }
        let dx = Double(p1.location.x - p2.location.x)
        let dy = Double(p1.location.y - p2.location.y)
        return min(1, max(0, sqrt(dx * dx + dy * dy) * 3.0))
    }
}
