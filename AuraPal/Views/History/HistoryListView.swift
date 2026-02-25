import SwiftUI
import SwiftData

struct HistoryListView: View {
    @ObservedObject var viewModel: HistoryViewModel
    @Query(sort: \AuraReading.createdAt, order: .reverse) private var readings: [AuraReading]

    var body: some View {
        VStack {
            Picker("Filter", selection: $viewModel.selectedAuraFilter) {
                Text("All").tag(AuraArchetype?.none)
                ForEach(AuraArchetype.allCases) { aura in
                    Text(aura.title).tag(AuraArchetype?.some(aura))
                }
            }
            .pickerStyle(.menu)

            List(viewModel.filter(readings: readings)) { reading in
                NavigationLink {
                    ReadingDetailView(reading: reading)
                } label: {
                    VStack(alignment: .leading) {
                        Text(reading.archetype.title)
                        Text(reading.createdAt.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(.top)
        .navigationTitle("History")
    }
}
