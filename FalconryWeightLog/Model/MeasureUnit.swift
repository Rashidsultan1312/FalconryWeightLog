import Foundation

struct Bird: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var species: BirdSpecies
    var fullWeight: Int
    var flyingWeight: Int
    var trainingWeight: Int
    var hatched: Date?
    var notes: String

    init(id: UUID = UUID(),
         name: String,
         species: BirdSpecies,
         fullWeight: Int? = nil,
         flyingWeight: Int? = nil,
         trainingWeight: Int? = nil,
         hatched: Date? = nil,
         notes: String = "") {
        self.id = id
        self.name = name
        self.species = species
        self.fullWeight = fullWeight ?? species.defaultFullWeight
        self.flyingWeight = flyingWeight ?? species.defaultFlyingWeight
        self.trainingWeight = trainingWeight ?? Int(Double(species.defaultFlyingWeight) * 1.04)
        self.hatched = hatched
        self.notes = notes
    }

    var weightTolerance: Int { max(8, fullWeight / 50) }
}

struct LogbookEntry: Identifiable, Codable, Hashable {
    let id: UUID
    var birdId: UUID
    var kind: LogbookKind
    var date: Date
    var weightGrams: Int?
    var feedKind: FeedKind?
    var feedGrams: Int?
    var note: String

    init(id: UUID = UUID(),
         birdId: UUID,
         kind: LogbookKind,
         date: Date = Date(),
         weightGrams: Int? = nil,
         feedKind: FeedKind? = nil,
         feedGrams: Int? = nil,
         note: String = "") {
        self.id = id
        self.birdId = birdId
        self.kind = kind
        self.date = date
        self.weightGrams = weightGrams
        self.feedKind = feedKind
        self.feedGrams = feedGrams
        self.note = note
    }
}
