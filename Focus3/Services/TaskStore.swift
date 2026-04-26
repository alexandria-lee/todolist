import Foundation
import Combine

@MainActor
final class TaskStore: ObservableObject {
    @Published var items: [TodoItem] = [] {
        didSet { save() }
    }

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("focus3-tasks.json")
    }()

    init() { load() }

    // MARK: - Querying

    var todaysThree: [TodoItem] {
        items.filter { $0.isToday && !$0.isCompleted }
    }

    var brainDump: [TodoItem] {
        items.filter { !$0.isToday && !$0.isCompleted }
            .sorted { $0.createdAt > $1.createdAt }
    }

    var completedToday: Int {
        let cal = Calendar.current
        return items.filter { $0.isCompleted && cal.isDateInToday($0.createdAt) }.count
    }

    // MARK: - Mutating

    func add(_ item: TodoItem) { items.append(item) }

    func toggleComplete(_ item: TodoItem) {
        guard let i = items.firstIndex(of: item) else { return }
        items[i].isCompleted.toggle()
    }

    func promoteToToday(_ item: TodoItem) {
        guard let i = items.firstIndex(of: item) else { return }
        // Enforce the Rule of 3 — only allow promotion if fewer than 3 already there.
        if todaysThree.count >= 3 { return }
        items[i].isToday = true
    }

    func demote(_ item: TodoItem) {
        guard let i = items.firstIndex(of: item) else { return }
        items[i].isToday = false
    }

    func delete(_ item: TodoItem) {
        items.removeAll { $0.id == item.id }
    }

    // MARK: - Persistence

    private func save() {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: fileURL, options: .atomic)
        } catch { /* swallow — app shouldn't crash on disk hiccups */ }
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) else { return }
        items = decoded
    }
}
