import Foundation
import Combine
import EventKit

@MainActor
final class EventKitService: ObservableObject {
    private let store = EKEventStore()

    @Published var todayEvents: [EKEvent] = []
    @Published var reminders: [EKReminder] = []
    @Published var calendarAccess = false
    @Published var remindersAccess = false

    func requestAccess() async {
        // iOS 17+ / macOS 14+ APIs
        do {
            calendarAccess = try await store.requestFullAccessToEvents()
        } catch {
            calendarAccess = false
        }
        do {
            remindersAccess = try await store.requestFullAccessToReminders()
        } catch {
            remindersAccess = false
        }
        await refresh()
    }

    func refresh() async {
        if calendarAccess { loadTodayEvents() }
        if remindersAccess { await loadReminders() }
    }

    private func loadTodayEvents() {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        let end = calendar.date(byAdding: .day, value: 1, to: start) ?? Date()
        let predicate = store.predicateForEvents(withStart: start, end: end, calendars: nil)
        todayEvents = store.events(matching: predicate).sorted { $0.startDate < $1.startDate }
    }

    private func loadReminders() async {
        let predicate = store.predicateForIncompleteReminders(withDueDateStarting: nil, ending: nil, calendars: nil)
        let fetched: [EKReminder] = await withCheckedContinuation { cont in
            store.fetchReminders(matching: predicate) { items in
                cont.resume(returning: items ?? [])
            }
        }
        self.reminders = fetched
    }

    /// Push a TodoItem into Apple Reminders so it shows up in Siri / watch / system Reminders app.
    @discardableResult
    func syncToReminders(_ item: TodoItem) -> String? {
        guard remindersAccess else { return nil }
        let reminder = EKReminder(eventStore: store)
        reminder.title = item.title
        reminder.notes = item.notes
        reminder.calendar = store.defaultCalendarForNewReminders()
        if let due = item.dueDate {
            reminder.dueDateComponents = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute], from: due)
        }
        do {
            try store.save(reminder, commit: true)
            return reminder.calendarItemIdentifier
        } catch {
            return nil
        }
    }
}
