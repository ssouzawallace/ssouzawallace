import Foundation

struct SleepSchedule: Codable {
    var bedtime: Date
    var wakeTime: Date
    var notificationsEnabled: Bool

    init() {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())

        components.hour = 22
        components.minute = 30
        bedtime = calendar.date(from: components) ?? Date()

        components.hour = 6
        components.minute = 30
        wakeTime = calendar.date(from: components) ?? Date()

        notificationsEnabled = true
    }

    var sleepDuration: TimeInterval {
        var duration = wakeTime.timeIntervalSince(bedtime)
        if duration < 0 {
            duration += 24 * 3600
        }
        return duration
    }

    var sleepDurationFormatted: String {
        let hours = Int(sleepDuration) / 3600
        let minutes = (Int(sleepDuration) % 3600) / 60
        if minutes == 0 {
            return "\(hours)h"
        }
        return "\(hours)h \(minutes)m"
    }
}
