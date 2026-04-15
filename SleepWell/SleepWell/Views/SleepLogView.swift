import SwiftUI

struct SleepLogView: View {
    @StateObject private var viewModel = SleepLogViewModel()
    @State private var showingAddLog = false

    var body: some View {
        NavigationStack {
            List {
                // Stats section
                if !viewModel.logs.isEmpty {
                    Section {
                        HStack(spacing: 12) {
                            StatCard(
                                title: "Avg Quality",
                                value: String(format: "%.1f / 5", viewModel.averageQuality),
                                icon: "star.fill",
                                color: .yellow
                            )
                            StatCard(
                                title: "Avg Sleep",
                                value: String(format: "%.1f hrs", viewModel.averageHours),
                                icon: "clock.fill",
                                color: .indigo
                            )
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .padding(.vertical, 4)
                    }
                }

                // Log history
                if viewModel.logs.isEmpty {
                    Section {
                        VStack(spacing: 12) {
                            Image(systemName: "moon.zzz.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(.indigo.opacity(0.4))
                            Text("No sleep logs yet")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            Text("Tap + to log your first night's sleep")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                        .listRowBackground(Color.clear)
                    }
                } else {
                    Section("History") {
                        ForEach(viewModel.logs) { log in
                            SleepLogRow(log: log)
                        }
                        .onDelete(perform: viewModel.delete)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Sleep Log")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddLog = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                if !viewModel.logs.isEmpty {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
            }
            .sheet(isPresented: $showingAddLog) {
                AddSleepLogView(viewModel: viewModel, isPresented: $showingAddLog)
            }
        }
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Log Row

struct SleepLogRow: View {
    let log: SleepLog

    var qualityColor: Color {
        switch log.quality {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .green
        case 5: return .mint
        default: return .gray
        }
    }

    var body: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(qualityColor)
                .frame(width: 12, height: 12)

            VStack(alignment: .leading, spacing: 3) {
                Text(log.date, style: .date)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                if !log.notes.isEmpty {
                    Text(log.notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text(log.qualityLabel)
                    .font(.caption)
                    .fontWeight(.medium)
                Text(String(format: "%.1fh", log.hoursSlept))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Add Log Sheet

struct AddSleepLogView: View {
    @ObservedObject var viewModel: SleepLogViewModel
    @Binding var isPresented: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section("Sleep Quality") {
                    VStack(spacing: 12) {
                        Text(viewModel.newLog.qualityLabel)
                            .font(.title3)
                            .fontWeight(.semibold)
                        HStack(spacing: 12) {
                            ForEach(1...5, id: \.self) { value in
                                Button {
                                    viewModel.newLog.quality = value
                                } label: {
                                    Image(systemName: viewModel.newLog.quality >= value ? "star.fill" : "star")
                                        .font(.title2)
                                        .foregroundStyle(.yellow)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }

                Section("Hours Slept") {
                    Slider(value: $viewModel.newLog.hoursSlept, in: 0...12, step: 0.5)
                        .tint(.indigo)
                    Text(String(format: "%.1f hours", viewModel.newLog.hoursSlept))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                Section("Date") {
                    DatePicker("Date", selection: $viewModel.newLog.date, displayedComponents: .date)
                }

                Section("Notes (optional)") {
                    TextField("How did you sleep?", text: $viewModel.newLog.notes, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
            }
            .navigationTitle("Log Sleep")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.addLog()
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    SleepLogView()
}
