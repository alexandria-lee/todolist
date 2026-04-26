import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Today", systemImage: "sun.max.fill") }

            BrainDumpView()
                .tabItem { Label("Brain Dump", systemImage: "tray.fill") }

            FocusTimerView()
                .tabItem { Label("Focus", systemImage: "timer") }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TaskStore())
        .environmentObject(EventKitService())
}
