import Foundation

struct SleepLog: Identifiable, Codable {
    let id: UUID
    let date: Date
    var quality: Int      // 1–5
    var hoursSlept: Double
    var notes: String

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        quality: Int = 3,
        hoursSlept: Double = 7.0,
        notes: String = ""
    ) {
        self.id = id
        self.date = date
        self.quality = quality
        self.hoursSlept = hoursSlept
        self.notes = notes
    }

    var qualityLabel: String {
        switch quality {
        case 1: return "😴 Poor"
        case 2: return "😕 Fair"
        case 3: return "😐 Okay"
        case 4: return "🙂 Good"
        case 5: return "😄 Great"
        default: return "Unknown"
        }
    }

    var qualityColor: String {
        switch quality {
        case 1: return "red"
        case 2: return "orange"
        case 3: return "yellow"
        case 4: return "green"
        case 5: return "mint"
        default: return "gray"
        }
    }
}
