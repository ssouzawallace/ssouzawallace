import Foundation

struct SleepHabit: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let iconName: String
    var isCompleted: Bool

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        iconName: String,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.iconName = iconName
        self.isCompleted = isCompleted
    }

    static let defaults: [SleepHabit] = [
        SleepHabit(
            title: "No caffeine after 2 PM",
            description: "Caffeine has a half-life of about 5 hours and can stay active in your system long past the afternoon.",
            iconName: "cup.and.saucer.fill"
        ),
        SleepHabit(
            title: "Dim lights 1 hour before bed",
            description: "Bright artificial light suppresses melatonin, the hormone that signals your body it's time to sleep.",
            iconName: "lightbulb.fill"
        ),
        SleepHabit(
            title: "No screens 30 minutes before bed",
            description: "Blue light from phones and TVs interferes with your natural sleep-wake cycle.",
            iconName: "iphone.slash"
        ),
        SleepHabit(
            title: "Keep bedroom cool (65–68°F / 18–20°C)",
            description: "A cooler room temperature mimics the body's natural temperature drop during sleep onset.",
            iconName: "thermometer.snowflake"
        ),
        SleepHabit(
            title: "Avoid large meals within 3 hours of bed",
            description: "Heavy digestion can cause discomfort and disrupt sleep quality.",
            iconName: "fork.knife"
        ),
        SleepHabit(
            title: "Get exercise (but not too late)",
            description: "Regular exercise improves sleep quality, but intense workouts within 2 hours of bedtime may be stimulating.",
            iconName: "figure.run"
        ),
        SleepHabit(
            title: "Consistent sleep and wake times",
            description: "Going to bed and waking up at the same time every day, even on weekends, strengthens your circadian rhythm.",
            iconName: "clock.fill"
        ),
        SleepHabit(
            title: "Wind-down relaxation routine",
            description: "Reading, gentle stretching, or meditation helps signal to your brain that it's time to sleep.",
            iconName: "leaf.fill"
        ),
        SleepHabit(
            title: "Limit alcohol",
            description: "Alcohol may help you fall asleep but significantly disrupts REM sleep and overall sleep quality.",
            iconName: "drop.fill"
        ),
        SleepHabit(
            title: "Get morning sunlight",
            description: "Natural light in the morning helps reset your circadian clock and improves alertness throughout the day.",
            iconName: "sun.max.fill"
        ),
    ]
}
