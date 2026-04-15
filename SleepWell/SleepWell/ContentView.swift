import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ScheduleView()
                .tabItem {
                    Label("Schedule", systemImage: "moon.stars.fill")
                }
            HabitsView()
                .tabItem {
                    Label("Habits", systemImage: "checkmark.circle.fill")
                }
            TipsView()
                .tabItem {
                    Label("Tips", systemImage: "lightbulb.fill")
                }
            SleepLogView()
                .tabItem {
                    Label("Log", systemImage: "chart.bar.fill")
                }
        }
        .tint(.indigo)
    }
}

#Preview {
    ContentView()
}
