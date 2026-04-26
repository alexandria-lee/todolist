import SwiftUI
import EventKit

struct TodayView: View {
    @EnvironmentObject var store: TaskStore
    @EnvironmentObject var eventKit: EventKitService

    var body: some View {
        NavigationStack {
            List {
                // ── Dopamine header ──
                Section {
                    HStack {
                        Text(greeting)
                            .font(.title2.bold())
                        Spacer()
                        if store.completedToday > 0 {
                            Label("\(store.completedToday) done", systemImage: "checkmark.seal.fill")
                                .foregroundStyle(.green)
                                .font(.subheadline.bold())
                        }
                    }
                }

                // ── Today's 3 ──
                Section {
                    if store.todaysThree.isEmpty {
                        ContentUnavailableView(
                            "Pick up to 3 tasks",
                            systemImage: "target",
                            description: Text("Open Brain Dump and tap the star on three things you’ll do today.")
                        )
                    } else {
                        ForEach(store.todaysThree) { item in
                            TaskRow(item: item)
                        }
                    }
                } header: {
                    HStack {
                        Text("Today's \(store.todaysThree.count)/3")
                        Spacer()
                        Text("Rule of 3").font(.caption).foregroundStyle(.secondary)
                    }
                }

                // ── Calendar context ──
                Section("On your calendar") {
                    if !eventKit.calendarAccess {
                        Text("Calendar access not granted. Enable it in System Settings → Privacy.")
                            .font(.footnote).foregroundStyle(.secondary)
                    } else if eventKit.todayEvents.isEmpty {
                        Text("No events today — wide-open day.")
                            .font(.footnote).foregroundStyle(.secondary)
                    } else {
                        ForEach(eventKit.todayEvents, id: \.eventIdentifier) { event in
                            EventRow(event: event)
                        }
                    }
                }
            }
            .navigationTitle("Focus3")
            .refreshable { await eventKit.refresh() }
        }
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "Good morning ☀️"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default:      return "Late night 🌙"
        }
    }
}

private struct EventRow: View {
    let event: EKEvent
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading) {
                Text(event.startDate, style: .time).font(.caption.monospacedDigit())
                Text(event.endDate, style: .time).font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            .frame(width: 60, alignment: .leading)
            Rectangle().fill(Color(cgColor: event.calendar.cgColor)).frame(width: 3)
            Text(event.title ?? "Untitled")
            Spacer()
        }
    }
}
