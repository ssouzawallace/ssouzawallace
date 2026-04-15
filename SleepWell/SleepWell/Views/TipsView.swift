import SwiftUI

struct SleepTip: Identifiable {
    let id = UUID()
    let category: String
    let title: String
    let body: String
    let icon: String
}

struct TipsView: View {
    let tips: [SleepTip] = [
        SleepTip(
            category: "Light & Environment",
            title: "Darkness matters",
            body: "Light is the strongest cue for your circadian clock. Even small amounts of light during sleep can fragment your rest. Use blackout curtains or a sleep mask.",
            icon: "moon.fill"
        ),
        SleepTip(
            category: "Light & Environment",
            title: "Temperature sweet spot",
            body: "Your body temperature naturally drops during sleep. Keeping your room between 65–68°F (18–20°C) supports this process and leads to deeper, more restorative sleep.",
            icon: "thermometer"
        ),
        SleepTip(
            category: "Light & Environment",
            title: "White noise can help",
            body: "Consistent background noise (fan, white noise machine) masks disruptive sounds and creates a stable sleep environment.",
            icon: "waveform"
        ),
        SleepTip(
            category: "Diet & Substances",
            title: "Caffeine's long reach",
            body: "Caffeine has a half-life of 5–7 hours. A coffee at 3 PM means 50% of the caffeine is still active at 9 PM, delaying sleep onset.",
            icon: "cup.and.saucer.fill"
        ),
        SleepTip(
            category: "Diet & Substances",
            title: "Alcohol disrupts deep sleep",
            body: "Alcohol may help you fall asleep faster but suppresses REM sleep and causes more wake-ups in the second half of the night.",
            icon: "drop.fill"
        ),
        SleepTip(
            category: "Diet & Substances",
            title: "Avoid heavy meals late",
            body: "Eating a large meal within 3 hours of bedtime forces your digestive system to stay active, raising core body temperature and disrupting sleep.",
            icon: "fork.knife"
        ),
        SleepTip(
            category: "Mind & Routine",
            title: "Consistent schedule is key",
            body: "Your circadian rhythm thrives on consistency. Varying your sleep schedule by even 1–2 hours on weekends creates 'social jet lag' that affects weekday performance.",
            icon: "clock.fill"
        ),
        SleepTip(
            category: "Mind & Routine",
            title: "Write away worry",
            body: "If racing thoughts keep you awake, write down your to-do list or worries before bed. Offloading to paper reduces cognitive arousal and helps you fall asleep faster.",
            icon: "pencil.line"
        ),
        SleepTip(
            category: "Mind & Routine",
            title: "Don't watch the clock",
            body: "Clock-watching while trying to sleep increases anxiety and arousal. Turn clocks away from view or remove them from the bedroom entirely.",
            icon: "eye.slash.fill"
        ),
        SleepTip(
            category: "Exercise & Activity",
            title: "Exercise improves sleep",
            body: "Regular aerobic exercise increases time in deep sleep and reduces sleep onset time — but finish intense workouts at least 2 hours before bed.",
            icon: "figure.run"
        ),
        SleepTip(
            category: "Exercise & Activity",
            title: "Morning sunlight resets you",
            body: "Getting 10–30 minutes of natural light in the morning sets your circadian clock, boosts mood, and makes it easier to feel sleepy at your target bedtime.",
            icon: "sun.max.fill"
        ),
        SleepTip(
            category: "Sleep Science",
            title: "Sleep cycles last ~90 minutes",
            body: "Sleep comes in 90-minute cycles of light, deep, and REM stages. Planning sleep in multiples of 90 minutes (6h, 7.5h, 9h) can help you wake at the end of a cycle feeling refreshed.",
            icon: "waveform.path.ecg"
        ),
        SleepTip(
            category: "Sleep Science",
            title: "Sleep debt accumulates",
            body: "Losing 1–2 hours per night accumulates as sleep debt that impairs cognition, mood, and immunity. You cannot fully recover on weekends — only consistent sleep repairs it.",
            icon: "exclamationmark.triangle.fill"
        ),
    ]

    var groupedTips: [(String, [SleepTip])] {
        let categories = Array(Set(tips.map(\.category))).sorted()
        return categories.map { category in
            (category, tips.filter { $0.category == category })
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedTips, id: \.0) { category, categoryTips in
                    Section(category) {
                        ForEach(categoryTips) { tip in
                            TipRow(tip: tip)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Sleep Science")
        }
    }
}

struct TipRow: View {
    let tip: SleepTip
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: tip.icon)
                        .foregroundStyle(.indigo)
                        .frame(width: 28)
                    Text(tip.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)

            if isExpanded {
                Text(tip.body)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TipsView()
}
