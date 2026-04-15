import Foundation
import UserNotifications

@MainActor
class ScheduleViewModel: ObservableObject {
    @Published var schedule: SleepSchedule

    private let storageKey = "sleepSchedule"

    init() {
        if let data = UserDefaults.standard.data(forKey: "sleepSchedule"),
           let saved = try? JSONDecoder().decode(SleepSchedule.self, from: data) {
            schedule = saved
        } else {
            schedule = SleepSchedule()
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(schedule) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
        if schedule.notificationsEnabled {
            scheduleNotifications()
        } else {
            cancelNotifications()
        }
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            Task { @MainActor in
                if granted {
                    self.schedule.notificationsEnabled = true
                }
                self.save()
            }
        }
    }

    private func scheduleNotifications() {
        cancelNotifications()
        let calendar = Calendar.current

        // Wind-down reminder (30 min before bed)
        let windDownTime = schedule.bedtime.addingTimeInterval(-30 * 60)
        let windDownComponents = calendar.dateComponents([.hour, .minute], from: windDownTime)
        let windDownContent = UNMutableNotificationContent()
        windDownContent.title = "🧘 Wind Down Time"
        windDownContent.body = "30 minutes until bedtime. Put away screens and start your relaxation routine."
        windDownContent.sound = .default
        let windDownRequest = UNNotificationRequest(
            identifier: "sleepwell.winddown",
            content: windDownContent,
            trigger: UNCalendarNotificationTrigger(dateMatching: windDownComponents, repeats: true)
        )
        UNUserNotificationCenter.current().add(windDownRequest)

        // Bedtime reminder
        let bedtimeComponents = calendar.dateComponents([.hour, .minute], from: schedule.bedtime)
        let bedtimeContent = UNMutableNotificationContent()
        bedtimeContent.title = "🌙 Time for Bed"
        bedtimeContent.body = "Your bedtime is now. Wind down and get ready for a great night's sleep."
        bedtimeContent.sound = .default
        let bedtimeRequest = UNNotificationRequest(
            identifier: "sleepwell.bedtime",
            content: bedtimeContent,
            trigger: UNCalendarNotificationTrigger(dateMatching: bedtimeComponents, repeats: true)
        )
        UNUserNotificationCenter.current().add(bedtimeRequest)

        // Wake-up reminder
        let wakeComponents = calendar.dateComponents([.hour, .minute], from: schedule.wakeTime)
        let wakeContent = UNMutableNotificationContent()
        wakeContent.title = "☀️ Good Morning!"
        wakeContent.body = "Rise and shine! Get some morning sunlight to reset your circadian clock."
        wakeContent.sound = .default
        let wakeRequest = UNNotificationRequest(
            identifier: "sleepwell.wake",
            content: wakeContent,
            trigger: UNCalendarNotificationTrigger(dateMatching: wakeComponents, repeats: true)
        )
        UNUserNotificationCenter.current().add(wakeRequest)
    }

    private func cancelNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["sleepwell.winddown", "sleepwell.bedtime", "sleepwell.wake"]
        )
    }
}
