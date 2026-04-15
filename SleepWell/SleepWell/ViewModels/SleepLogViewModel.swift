import Foundation

@MainActor
class SleepLogViewModel: ObservableObject {
    @Published var logs: [SleepLog]
    @Published var newLog: SleepLog = SleepLog()

    private let logsKey = "sleepLogs"

    init() {
        if let data = UserDefaults.standard.data(forKey: "sleepLogs"),
           let saved = try? JSONDecoder().decode([SleepLog].self, from: data) {
            logs = saved.sorted { $0.date > $1.date }
        } else {
            logs = []
        }
    }

    func addLog() {
        logs.insert(newLog, at: 0)
        save()
        newLog = SleepLog()
    }

    func delete(at offsets: IndexSet) {
        logs.remove(atOffsets: offsets)
        save()
    }

    var averageQuality: Double {
        guard !logs.isEmpty else { return 0 }
        return Double(logs.map(\.quality).reduce(0, +)) / Double(logs.count)
    }

    var averageHours: Double {
        guard !logs.isEmpty else { return 0 }
        return logs.map(\.hoursSlept).reduce(0, +) / Double(logs.count)
    }

    private func save() {
        if let data = try? JSONEncoder().encode(logs) {
            UserDefaults.standard.set(data, forKey: logsKey)
        }
    }
}
