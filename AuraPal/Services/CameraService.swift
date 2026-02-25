import Foundation
import AVFoundation
import SwiftUI

final class CameraService: NSObject, ObservableObject {
    enum Mode {
        case selfie
        case palm
    }

    @Published var authorizationDenied = false
    @Published var mode: Mode = .selfie

    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()

    override init() {
        super.init()
    }

    func configure(mode: Mode) {
        self.mode = mode
        session.beginConfiguration()
        session.sessionPreset = .photo

        for input in session.inputs {
            session.removeInput(input)
        }

        let position: AVCaptureDevice.Position = mode == .selfie ? .front : .back
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position),
              let input = try? AVCaptureDeviceInput(device: camera)
        else {
            session.commitConfiguration()
            return
        }

        if session.canAddInput(input) { session.addInput(input) }
        if session.canAddOutput(output), !session.outputs.contains(output) { session.addOutput(output) }
        session.commitConfiguration()
    }

    func requestAccess() async {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            authorizationDenied = false
        case .notDetermined:
            let granted = await withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    continuation.resume(returning: granted)
                }
            }
            authorizationDenied = !granted
        default:
            authorizationDenied = true
        }
    }
}

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let layer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer else { return }
        layer.session = session
        layer.frame = uiView.bounds
    }
}
