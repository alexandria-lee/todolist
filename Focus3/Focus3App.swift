import SwiftUI

@main
struct Focus3App: App {
    @StateObject private var taskStore = TaskStore()
    @StateObject private var eventKit = EventKitService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskStore)
                .environmentObject(eventKit)
                .task { await eventKit.requestAccess() }
        }
    }
}
