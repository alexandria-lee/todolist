# Focus3 — Project Context for Claude

## What this is
An ADHD-friendly todo list app for iOS (and eventually iPadOS / Mac Catalyst).
Built with **SwiftUI** + **EventKit**, targeting **iOS 17.6+**.

## Design philosophy
The app exists to **reduce friction and decision fatigue**, not to be a comprehensive task manager.

Three load-bearing principles — preserve them when adding features:

1. **Rule of 3** — you may only commit to 3 tasks per day. The constraint is the feature.
   Enforced in `TaskStore.promoteToToday`. Never weaken it without a strong reason.
2. **Energy matching** — every task has a Low / Medium / High energy tag so users can
   pick work that matches their current state.
3. **Externalize memory** — frictionless brain-dump capture, calendar context, sync to
   Apple Reminders so tasks reach Siri / Watch / lock screen.

## Tech stack & file layout
```
Focus3.xcodeproj/                 — Xcode project, edited via Xcode UI
Focus3/
  Focus3App.swift                 — app entry, injects TaskStore + EventKitService
  Models/TodoItem.swift           — task model (Codable, JSON-persisted)
  Services/
    TaskStore.swift               — @MainActor ObservableObject, JSON file persistence
    EventKitService.swift         — Calendar + Reminders bridge (iOS 17 FullAccess APIs)
  Views/
    ContentView.swift             — TabView container
    TodayView.swift               — today's 3 + calendar context
    BrainDumpView.swift           — quick capture inbox
    FocusTimerView.swift          — Pomodoro
    TaskRow.swift                 — shared task row component
  Assets.xcassets/                — icons + colors
```

## Build / run
- **Simulator**: open `Focus3.xcodeproj` in Xcode → run target "iPhone 17 Pro" → ▶︎
- **Real iPhone**: plug in, run target = device name → ▶︎
  (Personal Team signing; builds expire after 7 days.)
- Real Calendar/Reminders data only appears on the real device. Simulator has its own empty stores.

## Conventions
- Persistence: **JSON file** in Application Support (no Core Data / SwiftData).
- State management: **@StateObject + @EnvironmentObject** (no Redux-style stores).
- Concurrency: services are `@MainActor` — UI work always on main thread.
- iOS-only APIs: we use `requestFullAccessToEvents` (iOS 17+),
  `ContentUnavailableView` (iOS 17+), two-param `onChange` (iOS 17+). Don't downgrade these.

## Things NOT to do without explicit ask
- Don't add unit-test scaffolding, CI, linting, or new dependencies.
- Don't introduce a backend, account system, or sync server.
- Don't rebuild persistence in Core Data / SwiftData — JSON file is intentional.
- Don't soften the Rule of 3 (e.g., "allow 5 if user really wants").
- Don't collapse the tabs into one screen — the separation is deliberate.

## Out of scope (for now)
- Push notifications, widgets, Siri Shortcuts (good future work, but not yet)
- Apple Watch app
- Multi-device sync beyond what Reminders gives us for free
- Subtasks, projects, tags, recurring tasks (each would erode the simplicity)
