import SwiftUI

struct HabitsView: View {
    @StateObject private var viewModel = HabitsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    // Progress card
                    VStack(spacing: 10) {
                        HStack {
                            Text("Today's Progress")
                                .font(.headline)
                            Spacer()
                            Text("\(viewModel.completedCount) / \(viewModel.habits.count)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        ProgressView(value: viewModel.completionPercentage)
                            .tint(.indigo)
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                        if viewModel.completionPercentage == 1.0 {
                            Label("All habits complete — great sleep tonight! 🎉", systemImage: "star.fill")
                                .font(.caption)
                                .foregroundStyle(.indigo)
                        }
                    }
                    .padding()
                    .background(.indigo.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))

                    // Habits list
                    ForEach(viewModel.habits) { habit in
                        HabitRow(habit: habit) {
                            viewModel.toggle(habit)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Sleep Habits")
        }
    }
}

struct HabitRow: View {
    let habit: SleepHabit
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 14) {
                Image(systemName: habit.iconName)
                    .font(.title3)
                    .foregroundStyle(habit.isCompleted ? .white : .indigo)
                    .frame(width: 44, height: 44)
                    .background(
                        habit.isCompleted ? Color.indigo : Color.indigo.opacity(0.12),
                        in: Circle()
                    )

                VStack(alignment: .leading, spacing: 3) {
                    Text(habit.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .strikethrough(habit.isCompleted)
                        .foregroundStyle(habit.isCompleted ? .secondary : .primary)
                    Text(habit.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(habit.isCompleted ? .indigo : .secondary)
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HabitsView()
}
