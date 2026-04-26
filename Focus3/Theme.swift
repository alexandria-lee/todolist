import SwiftUI

enum Theme {
    static let background = Color(red: 0xFA / 255, green: 0xF9 / 255, blue: 0xF5 / 255)
    static let surface    = Color(red: 0xFF / 255, green: 0xFF / 255, blue: 0xFF / 255)
    static let ink        = Color(red: 0x2C / 255, green: 0x2B / 255, blue: 0x28 / 255)
    static let coral      = Color(red: 0xC1 / 255, green: 0x5F / 255, blue: 0x3C / 255)
}

enum Quotes {
    static let all: [String] = [
        "Small steps still move you forward.",
        "Done is better than perfect.",
        "You don't have to be fast. Just don't stop.",
        "Three things. That's enough.",
        "Start before you feel ready.",
        "Progress, not perfection.",
        "One task at a time.",
        "Discipline is choosing what you want most over what you want now.",
        "The hardest part is starting.",
        "Action is the antidote to anxiety.",
        "Focus on the next right thing.",
        "Show up. That's most of it.",
        "Your future self will thank you.",
        "Less, but better.",
        "Motion beats meditation."
    ]

    static func random() -> String {
        all.randomElement() ?? all[0]
    }
}
