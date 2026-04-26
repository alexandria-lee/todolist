import SwiftUI

struct TaskRow: View {
    @EnvironmentObject var store: TaskStore
    @EnvironmentObject var eventKit: EventKitService
    let item: TodoItem

    var body: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation { store.toggleComplete(item) }
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(item.isCompleted ? .green : .secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .strikethrough(item.isCompleted)
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)
                HStack(spacing: 6) {
                    Text("\(item.energy.emoji) \(item.energy.label)")
                    Text("· \(item.estimatedMinutes) min")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                store.delete(item)
            } label: { Label("Delete", systemImage: "trash") }

            if item.isToday {
                Button {
                    store.demote(item)
                } label: { Label("Move out", systemImage: "arrow.down") }
            }
        }
        .swipeActions(edge: .leading) {
            if !item.isToday {
                Button {
                    store.promoteToToday(item)
                } label: { Label("Today", systemImage: "star.fill") }
                .tint(.yellow)
            }
            Button {
                if let id = eventKit.syncToReminders(item) {
                    var copy = item
                    copy.reminderId = id
                    if let i = store.items.firstIndex(of: item) {
                        store.items[i] = copy
                    }
                }
            } label: { Label("Reminders", systemImage: "bell") }
            .tint(.blue)
        }
    }
}
