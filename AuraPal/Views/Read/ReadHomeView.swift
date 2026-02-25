import SwiftUI

struct ReadHomeView: View {
    @ObservedObject var viewModel: ReadViewModel

    @State private var showCamera = false
    @StateObject private var resultVM = ResultViewModel()
    @Environment(\.modelContext) private var modelContext

    private let moods = ["Calm", "Focused", "Curious", "Social", "Restless"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("AuraPal")
                    .font(.largeTitle.bold())
                Text("Entertainment + self-reflection only")
                    .foregroundStyle(.secondary)
                    .accessibilityLabel("Entertainment and self reflection only")

                Picker("Scan type", selection: $viewModel.selectedMode) {
                    ForEach(ReadViewModel.ScanMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)

                HStack(spacing: 12) {
                    Button("Selfie Aura") {
                        viewModel.selectedMode = .selfieAura
                        showCamera = true
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Palm Scan") {
                        viewModel.selectedMode = .palmScan
                        showCamera = true
                    }
                    .buttonStyle(.bordered)
                }

                Text("Quick Mood")
                    .font(.headline)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))]) {
                    ForEach(moods, id: \.self) { mood in
                        let selected = viewModel.quickMoodTags.contains(mood)
                        Text(mood)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(selected ? Color.purple.opacity(0.4) : Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture {
                                if selected {
                                    viewModel.quickMoodTags.remove(mood)
                                } else {
                                    viewModel.quickMoodTags.insert(mood)
                                }
                            }
                    }
                }

                Button("Reveal Reading") {
                    Task { await viewModel.revealReading() }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.selectedImage == nil)

                if viewModel.isScanning {
                    ScanProgressView()
                }

                if let aura = viewModel.latestAura, let horoscope = viewModel.latestHoroscope {
                    ResultView(
                        aura: aura,
                        palm: viewModel.latestPalm,
                        horoscope: horoscope,
                        faceRect: viewModel.faceRect
                    )

                    Button("Save Reading") {
                        resultVM.save(aura: aura, palm: viewModel.latestPalm, horoscope: horoscope, context: modelContext)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showCamera) {
            CameraCaptureView(viewModel: viewModel)
        }
    }
}
