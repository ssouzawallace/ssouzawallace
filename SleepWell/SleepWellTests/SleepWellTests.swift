import XCTest
@testable import SleepWell

final class SleepWellTests: XCTestCase {

    // MARK: - SleepSchedule

    func testSleepScheduleDefaultDuration() {
        let schedule = SleepSchedule()
        // Default: 10:30 PM → 6:30 AM = 8 hours
        XCTAssertEqual(schedule.sleepDuration, 8 * 3600, accuracy: 60)
    }

    func testSleepScheduleDurationFormattedNotEmpty() {
        let schedule = SleepSchedule()
        XCTAssertFalse(schedule.sleepDurationFormatted.isEmpty)
    }

    func testSleepScheduleDurationPositiveWhenCrossesMidnight() {
        var schedule = SleepSchedule()
        let calendar = Calendar.current
        var bedComps = calendar.dateComponents([.year, .month, .day], from: Date())
        bedComps.hour = 23; bedComps.minute = 0
        schedule.bedtime = calendar.date(from: bedComps) ?? Date()

        var wakeComps = calendar.dateComponents([.year, .month, .day], from: Date())
        wakeComps.hour = 7; wakeComps.minute = 0
        schedule.wakeTime = calendar.date(from: wakeComps) ?? Date()

        XCTAssertGreaterThan(schedule.sleepDuration, 0)
    }

    func testSleepScheduleFormattedHoursOnly() {
        var schedule = SleepSchedule()
        let calendar = Calendar.current
        var bedComps = calendar.dateComponents([.year, .month, .day], from: Date())
        bedComps.hour = 22; bedComps.minute = 0
        schedule.bedtime = calendar.date(from: bedComps) ?? Date()

        var wakeComps = calendar.dateComponents([.year, .month, .day], from: Date())
        wakeComps.hour = 6; wakeComps.minute = 0
        schedule.wakeTime = calendar.date(from: wakeComps) ?? Date()

        XCTAssertEqual(schedule.sleepDurationFormatted, "8h")
    }

    // MARK: - SleepHabit

    func testDefaultHabitsCount() {
        XCTAssertEqual(SleepHabit.defaults.count, 10)
    }

    func testDefaultHabitsAllUncompleted() {
        XCTAssertTrue(SleepHabit.defaults.allSatisfy { !$0.isCompleted })
    }

    func testDefaultHabitsHaveUniqueIDs() {
        let ids = SleepHabit.defaults.map(\.id)
        XCTAssertEqual(ids.count, Set(ids).count)
    }

    // MARK: - SleepLog

    func testSleepLogQualityLabels() {
        XCTAssertTrue(SleepLog(quality: 1).qualityLabel.contains("Poor"))
        XCTAssertTrue(SleepLog(quality: 2).qualityLabel.contains("Fair"))
        XCTAssertTrue(SleepLog(quality: 3).qualityLabel.contains("Okay"))
        XCTAssertTrue(SleepLog(quality: 4).qualityLabel.contains("Good"))
        XCTAssertTrue(SleepLog(quality: 5).qualityLabel.contains("Great"))
    }

    func testSleepLogDefaultValues() {
        let log = SleepLog()
        XCTAssertEqual(log.quality, 3)
        XCTAssertEqual(log.hoursSlept, 7.0)
        XCTAssertTrue(log.notes.isEmpty)
    }
}
