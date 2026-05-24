import SwiftUI

struct VogelScreen: View {
    @EnvironmentObject private var ledger: WeightLedger
    @State private var editing: Bird? = nil
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(ledger.birds) { bird in
                        BirdCard(bird: bird, isActive: bird.id == ledger.activeBirdId)
                            .onTapGesture {
                                ledger.activeBirdId = bird.id
                            }
                            .contextMenu {
                                Button("voegel.edit") { editing = bird }
                                Button("voegel.delete", role: .destructive) { ledger.removeBird(bird) }
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            .background(FieldCanvas(opacity: 0.32, imageName: "Backdrops/bd-perch"))
            .navigationTitle("tab.voegel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingAdd = true } label: {
                        Image(systemName: "plus.circle.fill").foregroundStyle(Palette.accent)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAdd) {
            BirdEditor(bird: nil) { saved in ledger.appendBird(saved) }
        }
        .sheet(item: $editing) { bird in
            BirdEditor(bird: bird) { saved in ledger.updateBird(saved) }
        }
    }
}

struct LogbuchScreen: View {
    @EnvironmentObject private var ledger: WeightLedger
    @State private var filter: LogbookKind? = nil

    var body: some View {
        NavigationStack {
            Group {
                if let bird = ledger.activeBird {
                    let filtered = ledger.entries(for: bird, kind: filter)
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ChipButton("logbuch.filter.all",
                                               selected: filter == nil) { filter = nil }
                                    ForEach(LogbookKind.allCases) { kind in
                                        ChipButton(LocalizedStringKey(kind.titleKey),
                                                   symbol: kind.symbol,
                                                   selected: filter == kind) {
                                            filter = filter == kind ? nil : kind
                                        }
                                    }
                                }
                            }
                            if filtered.isEmpty {
                                EmptyStateBox(symbol: "book.closed",
                                              titleKey: "logbuch.empty.title",
                                              messageKey: "logbuch.empty.body")
                            } else {
                                VStack(spacing: 10) {
                                    ForEach(filtered) { entry in
                                        LogbookRow(entry: entry, bird: bird)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                    }
                } else {
                    EmptyStateBox(symbol: "bird",
                                  titleKey: "heute.empty.title",
                                  messageKey: "heute.empty.body")
                        .padding(20)
                }
            }
            .background(FieldCanvas(opacity: 0.32, imageName: "Backdrops/bd-hawking-bag"))
            .navigationTitle("tab.logbuch")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct BirdCard: View {
    let bird: Bird
    let isActive: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(isActive ? bird.species.tint.opacity(0.16) : Palette.cardFill)
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(isActive ? bird.species.tint : .clear, lineWidth: 2)
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(bird.species.tint.opacity(0.22))
                        .frame(width: 56, height: 56)
                    Image(systemName: "bird.fill")
                        .font(.title)
                        .foregroundStyle(bird.species.tint)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(bird.name)
                        .font(.system(.headline, design: .serif).weight(.bold))
                    Text(LocalizedStringKey(bird.species.nameKey))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(bird.species.latinName)
                        .font(.system(.caption, design: .serif).italic())
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(bird.flyingWeight)g")
                        .font(.system(.title3, design: .monospaced).weight(.bold))
                        .foregroundStyle(Palette.accent)
                    Text("voegel.flying")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(16)
        }
    }
}

private struct LogbookRow: View {
    let entry: LogbookEntry
    let bird: Bird

    var body: some View {
        RoundedCard {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(bird.species.tint.opacity(0.18))
                        .frame(width: 40, height: 40)
                    Image(systemName: entry.kind.symbol)
                        .foregroundStyle(bird.species.tint)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(LocalizedStringKey(entry.kind.titleKey))
                        .font(.subheadline.weight(.semibold))
                    if let grams = entry.weightGrams {
                        Text("\(grams) g")
                            .font(.system(.subheadline, design: .monospaced).weight(.bold))
                            .foregroundStyle(Palette.accent)
                    }
                    if let feed = entry.feedKind, let grams = entry.feedGrams {
                        Text("\(grams) g · \(NSLocalizedString(feed.nameKey, comment: ""))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    if !entry.note.isEmpty {
                        Text(entry.note).font(.caption).foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Text(entry.date, format: .dateTime.day().month().hour().minute())
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct BirdEditor: View {
    let bird: Bird?
    let onSave: (Bird) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var species: BirdSpecies
    @State private var fullWeight: Int
    @State private var flyingWeight: Int
    @State private var trainingWeight: Int
    @State private var notes: String

    init(bird: Bird?, onSave: @escaping (Bird) -> Void) {
        self.bird = bird
        self.onSave = onSave
        _name = State(initialValue: bird?.name ?? "")
        _species = State(initialValue: bird?.species ?? .habicht)
        _fullWeight = State(initialValue: bird?.fullWeight ?? BirdSpecies.habicht.defaultFullWeight)
        _flyingWeight = State(initialValue: bird?.flyingWeight ?? BirdSpecies.habicht.defaultFlyingWeight)
        _trainingWeight = State(initialValue: bird?.trainingWeight ?? Int(Double(BirdSpecies.habicht.defaultFlyingWeight) * 1.04))
        _notes = State(initialValue: bird?.notes ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("voegel.field.name") {
                    TextField("voegel.field.name.placeholder", text: $name)
                }
                Section("voegel.field.species") {
                    Picker("voegel.field.species", selection: $species) {
                        ForEach(BirdSpecies.allCases) { s in
                            Text(LocalizedStringKey(s.nameKey)).tag(s)
                        }
                    }
                }
                Section("voegel.field.weights") {
                    Stepper(value: $fullWeight, in: 50...8000, step: 10) {
                        HStack { Text("voegel.field.full"); Spacer(); Text("\(fullWeight) g").foregroundStyle(.secondary) }
                    }
                    Stepper(value: $flyingWeight, in: 50...8000, step: 5) {
                        HStack { Text("voegel.field.flying"); Spacer(); Text("\(flyingWeight) g").foregroundStyle(Palette.accent) }
                    }
                    Stepper(value: $trainingWeight, in: 50...8000, step: 5) {
                        HStack { Text("voegel.field.training"); Spacer(); Text("\(trainingWeight) g").foregroundStyle(.secondary) }
                    }
                }
                Section("voegel.field.notes") {
                    TextEditor(text: $notes).frame(minHeight: 80)
                }
            }
            .navigationTitle(bird == nil ? "voegel.add" : "voegel.edit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("action.cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("action.save") {
                        let saved = Bird(id: bird?.id ?? UUID(),
                                         name: name.trimmingCharacters(in: .whitespaces),
                                         species: species,
                                         fullWeight: fullWeight,
                                         flyingWeight: flyingWeight,
                                         trainingWeight: trainingWeight,
                                         notes: notes)
                        onSave(saved)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
