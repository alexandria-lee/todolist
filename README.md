# Focus3 — an ADHD-friendly todo list

A native iOS + macOS app built with SwiftUI. Designed around three ADHD-aware ideas:

1. **Rule of 3** — only three tasks can live in "Today" at once. The constraint is the feature.
2. **Energy matching** — every task is tagged Low / Medium / High focus, so you can pick work that matches your current state.
3. **Externalize memory** — a frictionless Brain Dump inbox + a built-in Pomodoro timer + sync to Apple Reminders so your tasks reach Siri, Apple Watch, and your iPhone lock screen.

## What's in this repo

```
Focus3/
├── Focus3App.swift          # app entry point
├── Models/
│   └── TodoItem.swift       # task data structure
├── Services/
│   ├── EventKitService.swift  # Apple Calendar + Reminders bridge
│   └── TaskStore.swift        # local persistence (JSON on disk)
└── Views/
    ├── ContentView.swift      # the 3 tabs
    ├── TodayView.swift        # Today's 3 + calendar context
    ├── BrainDumpView.swift    # quick capture inbox
    ├── FocusTimerView.swift   # Pomodoro
    └── TaskRow.swift          # one task row (shared component)
```

## How to run it on your Mac

You need **Xcode** (free in the Mac App Store, ~7GB).

1. Open Xcode → **File → New → Project…**
2. Choose **iOS → App**, click **Next**.
3. Fill in:
   - **Product Name:** `Focus3`
   - **Interface:** SwiftUI
   - **Language:** Swift
   - **Storage:** None
   - Tick **Include Tests** off (optional)
4. Save it inside this repo folder (`todolist/`). When prompted "create git repository," **uncheck it** (we already have one).
5. In the left sidebar (Project Navigator), delete the default `Focus3App.swift` and `ContentView.swift` Xcode created — choose **Move to Trash**.
6. Drag the `Focus3/` folder from Finder into the Xcode sidebar (drop it on the blue project icon). When prompted, tick **Copy items if needed** OFF and **Create groups**.
7. Click the project icon at the top of the sidebar → **Focus3 target** → **Info** tab. Add two rows:
   - `Privacy - Calendars Usage Description` → "Focus3 shows your events alongside your tasks so you don't double-book your time."
   - `Privacy - Reminders Usage Description` → "Focus3 syncs tasks to Apple Reminders so they appear on your iPhone and watch."
8. Hit the ▶︎ Play button (top-left). Choose "My Mac" or an iPhone simulator.

## How to run it on your iPhone

1. Plug your iPhone in with a cable. Trust the computer.
2. In Xcode's top bar, change the run target from "iPhone Simulator" to **your iPhone's name**.
3. Click the project → **Signing & Capabilities** → tick **Automatically manage signing** → choose your **Personal Team** (your free Apple ID).
4. Hit ▶︎. The first time, your iPhone will refuse to open the app — go to **Settings → General → VPN & Device Management** and trust your developer profile.
5. App icon appears on the home screen. Free Apple ID builds expire after 7 days; just rebuild from Xcode to refresh.

For a permanent install (no expiry, plus App Store distribution), you need a paid **Apple Developer Program** membership ($99/year).

## ADHD-friendly design notes

| Feature                | Why it helps                                                    |
|------------------------|------------------------------------------------------------------|
| Rule of 3              | Choice paralysis is the enemy. Three is plannable.              |
| Energy emoji + minutes | Lets you pick a task that fits your current capacity.           |
| Calendar context       | See meetings without switching apps — prevents over-committing. |
| Brain Dump             | Get thoughts out of your head fast so they stop bouncing around.|
| Pomodoro               | Time becomes visible. The circle shrinks — your brain notices.  |
| Reminders sync         | Siri, Watch, and iPhone widgets all "just work."                |
