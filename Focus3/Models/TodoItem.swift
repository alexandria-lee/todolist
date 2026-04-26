import Foundation

enum Energy: String, Codable, CaseIterable, Identifiable {
    case low, medium, high
    var id: String { rawValue }

    var label: String {
        switch self {
        case .low: return "Low energy"
        case .medium: return "Medium"
        case .high: return "High focus"
        }
    }

    var emoji: String {
        switch self {
        case .low: return "🌱"
        case .medium: return "⚡️"
        case .high: return "🔥"
        }
    }
}

struct TodoItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var notes: String = ""
    var energy: Energy = .medium
    var estimatedMinutes: Int = 25
    var isCompleted: Bool = false
    var isToday: Bool = false           // promoted to "Today's 3"
    var dueDate: Date? = nil
    var createdAt: Date = Date()
    var reminderId: String? = nil       // links to Apple Reminders item
}
