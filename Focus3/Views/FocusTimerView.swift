import SwiftUI

struct FocusTimerView: View {
    @State private var totalSeconds: Int = 25 * 60
    @State private var remaining: Int = 25 * 60
    @State private var isRunning = false
    @State private var timer: Timer?

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Text("Pomodoro")
                    .font(.title.bold())

                ZStack {
                    Circle()
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 14)
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 0.25), value: remaining)
                    Text(timeString)
                        .font(.system(size: 64, weight: .bold, design: .rounded).monospacedDigit())
                }
                .frame(width: 260, height: 260)
                .padding(.horizontal, 32)

                HStack(spacing: 20) {
                    Button(isRunning ? "Pause" : "Start", action: toggle)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    Button("Reset", action: reset)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                }

                Picker("Length", selection: $totalSeconds) {
                    Text("15 min").tag(15 * 60)
                    Text("25 min").tag(25 * 60)
                    Text("50 min").tag(50 * 60)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 32)
                .onChange(of: totalSeconds) { _, new in
                    if !isRunning { remaining = new }
                }

                Text("Pick one task. One block. No tabs. Go.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding(.top, 32)
            .navigationTitle("Focus")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var progress: CGFloat {
        guard totalSeconds > 0 else { return 0 }
        return CGFloat(totalSeconds - remaining) / CGFloat(totalSeconds)
    }

    private var timeString: String {
        String(format: "%02d:%02d", remaining / 60, remaining % 60)
    }

    private func toggle() {
        isRunning ? pause() : start()
    }

    private func start() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remaining > 0 {
                remaining -= 1
            } else {
                pause()
            }
        }
    }

    private func pause() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    private func reset() {
        pause()
        remaining = totalSeconds
    }
}
