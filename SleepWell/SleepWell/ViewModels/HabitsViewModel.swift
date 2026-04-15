import Foundation

@MainActor
class HabitsViewModel: ObservableObject {
    @Published var habits: [SleepHabit]

    private let habitsKey = "sleepHabits"
    private let resetDateKey = "lastHabitResetDate"

    init() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let savedResetDate = (UserDefaults.standard.object(forKey: "lastHabitResetDate") as? Date) ?? .distantPast
        let savedDay = calendar.startOfDay(for: savedResetDate)

        if let data = UserDefaults.standard.data(forKey: "sleepHabits"),
           let saved = try? JSONDecoder().decode([SleepHabit].self, from: data) {
            if savedDay < today {
                // New day: reset all completions
                habits = saved.map { var h = $0; h.isCompleted = false; return h }
                UserDefaults.standard.set(today, forKey: "lastHabitResetDate")
                Self.persist(habits: habits, key: "sleepHabits")
            } else {
                habits = saved
            }
        } else {
            habits = SleepHabit.defaults
            UserDefaults.standard.set(today, forKey: "lastHabitResetDate")
            Self.persist(habits: habits, key: "sleepHabits")
        }
    }

    func toggle(_ habit: SleepHabit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index].isCompleted.toggle()
        save()
    }

    var completedCount: Int { habits.filter(\.isCompleted).count }

    var completionPercentage: Double {
        guard !habits.isEmpty else { return 0 }
        return Double(completedCount) / Double(habits.count)
    }

    private func save() {
        Self.persist(habits: habits, key: habitsKey)
    }

    private static func persist(habits: [SleepHabit], key: String) {
        if let data = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
