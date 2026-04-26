import SwiftUI

struct BrainDumpView: View {
    @EnvironmentObject var store: TaskStore
    @State private var draft: String = ""
    @State private var energy: Energy = .medium
    @State private var minutes: Int = 25

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // ── Quick capture ──
                HStack {
                    TextField("What's on your mind?", text: $draft)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit(commit)
                    Button("Add", action: commit)
                        .buttonStyle(.borderedProminent)
                        .disabled(draft.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()

                HStack {
                    Picker("Energy", selection: $energy) {
                        ForEach(Energy.allCases) { e in
                            Text("\(e.emoji) \(e.label)").tag(e)
                        }
                    }
                    .pickerStyle(.segmented)

                    Stepper("\(minutes) min", value: $minutes, in: 5...180, step: 5)
                        .frame(maxWidth: 160)
                }
                .padding(.horizontal)

                // ── List of unsorted thoughts ──
                List {
                    Section("Inbox · \(store.brainDump.count)") {
                        if store.brainDump.isEmpty {
                            Text("Empty. Nice and clean. ✨")
                                .foregroundStyle(.secondary)
                        }
                        ForEach(store.brainDump) { item in
                            TaskRow(item: item)
                        }
                    }
                }
            }
            .navigationTitle("Brain Dump")
        }
    }

    private func commit() {
        let title = draft.trimmingCharacters(in: .whitespaces)
        guard !title.isEmpty else { return }
        store.add(TodoItem(title: title, energy: energy, estimatedMinutes: minutes))
        draft = ""
    }
}
