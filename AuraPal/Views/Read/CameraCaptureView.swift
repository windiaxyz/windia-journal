import SwiftUI
import PhotosUI

struct CameraCaptureView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ReadViewModel

    @StateObject private var camera = CameraService()
    @State private var pickerItem: PhotosPickerItem?

    var body: some View {
        ZStack {
            CameraPreviewView(session: camera.session)
                .ignoresSafeArea()

            VStack {
                Text(viewModel.selectedMode == .selfieAura ? "Align your face in frame" : "Align your palm in the guide")
                    .font(.headline)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .padding(.top, 16)

                Spacer()

                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white.opacity(0.7), style: StrokeStyle(lineWidth: 3, dash: [8]))
                    .frame(width: 260, height: viewModel.selectedMode == .selfieAura ? 320 : 240)
                    .overlay(alignment: .bottom) {
                        if viewModel.selectedMode == .palmScan {
                            Text("Quality: \(Int(viewModel.palmQuality * 100))")
                                .padding(6)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                                .padding(.bottom, 10)
                        }
                    }

                Spacer()

                HStack {
                    PhotosPicker(selection: $pickerItem, matching: .images) {
                        Label("Photos", systemImage: "photo")
                    }
                    .buttonStyle(.bordered)

                    Button {
                        // For this sample, use photo picker workflow as deterministic input source.
                    } label: {
                        Circle().fill(Color.white).frame(width: 72, height: 72)
                    }
                    .accessibilityLabel("Capture")

                    Button("Done") { dismiss() }
                        .buttonStyle(.bordered)
                }
                .padding(.bottom, 28)
            }
            .padding()
        }
        .task {
            await camera.requestAccess()
            camera.configure(mode: viewModel.selectedMode == .selfieAura ? .selfie : .palm)
            camera.session.startRunning()
        }
        .onDisappear { camera.session.stopRunning() }
        .onChange(of: pickerItem) { _, newValue in
            guard let newValue else { return }
            Task {
                if let data = try? await newValue.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    viewModel.selectedImage = image
                    dismiss()
                }
            }
        }
    }
}
