import SwiftUI

struct ScheduleView: View {
    @StateObject private var viewModel = ScheduleViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // Sleep duration summary card
                    VStack(spacing: 6) {
                        Text("Planned Sleep")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(viewModel.schedule.sleepDurationFormatted)
                            .font(.system(size: 56, weight: .bold, design: .rounded))
                            .foregroundStyle(.indigo)
                        Text("per night")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(.indigo.opacity(0.1), in: RoundedRectangle(cornerRadius: 20))

                    // Bedtime picker
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Bedtime", systemImage: "moon.fill")
                            .font(.headline)
                            .foregroundStyle(.indigo)
                        DatePicker(
                            "Bedtime",
                            selection: $viewModel.schedule.bedtime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))

                    // Wake time picker
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Wake Time", systemImage: "sun.horizon.fill")
                            .font(.headline)
                            .foregroundStyle(.orange)
                        DatePicker(
                            "Wake Time",
                            selection: $viewModel.schedule.wakeTime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))

                    // Notifications toggle
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle(isOn: $viewModel.schedule.notificationsEnabled) {
                            Label("Bedtime Reminders", systemImage: "bell.fill")
                                .font(.headline)
                        }
                        .tint(.indigo)
                        Text("You'll be notified 30 min before bed, at bedtime, and at wake time.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))

                    // Save button
                    Button {
                        if viewModel.schedule.notificationsEnabled {
                            viewModel.requestNotificationPermission()
                        } else {
                            viewModel.save()
                        }
                    } label: {
                        Text("Save Schedule")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.indigo, in: RoundedRectangle(cornerRadius: 16))
                            .foregroundStyle(.white)
                    }
                }
                .padding()
            }
            .navigationTitle("Sleep Schedule")
        }
    }
}

#Preview {
    ScheduleView()
}
