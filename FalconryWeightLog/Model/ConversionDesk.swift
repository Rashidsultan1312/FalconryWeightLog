import SwiftUI

enum AppearanceMode: String, CaseIterable, Identifiable, Codable {
    case system
    case dark
    case light
    var id: String { rawValue }
    var label: LocalizedStringKey {
        switch self {
        case .system: return "appearance.system"
        case .dark:   return "appearance.dark"
        case .light:  return "appearance.light"
        }
    }
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .dark:   return .dark
        case .light:  return .light
        }
    }
}

enum WeightUnit: String, CaseIterable, Identifiable, Codable {
    case grams
    case ounces
    var id: String { rawValue }
    var titleKey: String { "unit.\(rawValue)" }
}

@MainActor
final class WeightLedger: ObservableObject {
    @Published var birds: [Bird] = [] { didSet { persistBirds() } }
    @Published var entries: [LogbookEntry] = [] { didSet { persistEntries() } }
    @Published var activeBirdId: UUID? = nil { didSet { persistPrefs() } }
    @Published var appearance: AppearanceMode = .system { didSet { persistPrefs() } }
    @Published var weightUnit: WeightUnit = .grams { didSet { persistPrefs() } }

    private let defaults = UserDefaults.standard
    private let kBirds = "fw.log.birds"
    private let kEntries = "fw.log.entries"
    private let kActive = "fw.pref.active"
    private let kApp = "fw.pref.appearance"
    private let kUnit = "fw.pref.unit"

    init() {
        restore()
        if birds.isEmpty { seedDefaultBird() }
    }

    var activeBird: Bird? {
        guard let id = activeBirdId else { return birds.first }
        return birds.first { $0.id == id } ?? birds.first
    }

    func appendBird(_ bird: Bird) {
        var bag = birds
        bag.append(bird)
        birds = bag
        if activeBirdId == nil { activeBirdId = bird.id }
    }

    func updateBird(_ bird: Bird) {
        guard let idx = birds.firstIndex(where: { $0.id == bird.id }) else { return }
        birds[idx] = bird
    }

    func removeBird(_ bird: Bird) {
        birds.removeAll { $0.id == bird.id }
        entries.removeAll { $0.birdId == bird.id }
        if activeBirdId == bird.id { activeBirdId = birds.first?.id }
    }

    func append(_ entry: LogbookEntry) {
        var bag = entries
        bag.insert(entry, at: 0)
        entries = bag
    }

    func entries(for bird: Bird, kind: LogbookKind? = nil) -> [LogbookEntry] {
        entries.filter { $0.birdId == bird.id && (kind == nil || $0.kind == kind) }
    }

    func recentWeights(for bird: Bird, days: Int = 7) -> [LogbookEntry] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return entries
            .filter { $0.birdId == bird.id && $0.kind == .weighing && $0.date >= cutoff && $0.weightGrams != nil }
            .sorted { $0.date < $1.date }
    }

    func wipeBirdData(_ bird: Bird) {
        entries.removeAll { $0.birdId == bird.id }
    }

    private func seedDefaultBird() {
        let bird = Bird(name: NSLocalizedString("default.bird.name", comment: ""),
                        species: .habicht,
                        notes: "")
        appendBird(bird)
    }

    private func persistBirds() {
        if let data = try? JSONEncoder().encode(birds) { defaults.set(data, forKey: kBirds) }
    }

    private func persistEntries() {
        if let data = try? JSONEncoder().encode(entries) { defaults.set(data, forKey: kEntries) }
    }

    private func persistPrefs() {
        defaults.set(activeBirdId?.uuidString, forKey: kActive)
        defaults.set(appearance.rawValue, forKey: kApp)
        defaults.set(weightUnit.rawValue, forKey: kUnit)
    }

    private func restore() {
        if let data = defaults.data(forKey: kBirds),
           let decoded = try? JSONDecoder().decode([Bird].self, from: data) { birds = decoded }
        if let data = defaults.data(forKey: kEntries),
           let decoded = try? JSONDecoder().decode([LogbookEntry].self, from: data) { entries = decoded }
        if let raw = defaults.string(forKey: kActive), let uuid = UUID(uuidString: raw) { activeBirdId = uuid }
        if let raw = defaults.string(forKey: kApp), let m = AppearanceMode(rawValue: raw) { appearance = m }
        if let raw = defaults.string(forKey: kUnit), let u = WeightUnit(rawValue: raw) { weightUnit = u }
    }
}
