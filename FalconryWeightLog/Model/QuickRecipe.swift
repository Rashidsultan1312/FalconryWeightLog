import Foundation

struct SpeciesProfile: Identifiable, Hashable {
    var id: String { species.rawValue }
    let species: BirdSpecies
    let habitatKey: String
    let preyKey: String
    let temperamentKey: String
}

enum SpeciesProfileCatalog {
    static let all: [SpeciesProfile] = [
        .init(species: .habicht,    habitatKey: "species.habicht.habitat",    preyKey: "species.habicht.prey",    temperamentKey: "species.habicht.temperament"),
        .init(species: .wanderfalke,habitatKey: "species.wanderfalke.habitat",preyKey: "species.wanderfalke.prey",temperamentKey: "species.wanderfalke.temperament"),
        .init(species: .sperber,    habitatKey: "species.sperber.habitat",    preyKey: "species.sperber.prey",    temperamentKey: "species.sperber.temperament"),
        .init(species: .steinadler, habitatKey: "species.steinadler.habitat", preyKey: "species.steinadler.prey", temperamentKey: "species.steinadler.temperament"),
        .init(species: .turmfalke,  habitatKey: "species.turmfalke.habitat",  preyKey: "species.turmfalke.prey",  temperamentKey: "species.turmfalke.temperament"),
        .init(species: .rotmilan,   habitatKey: "species.rotmilan.habitat",   preyKey: "species.rotmilan.prey",   temperamentKey: "species.rotmilan.temperament")
    ]

    static func profile(for species: BirdSpecies) -> SpeciesProfile {
        all.first { $0.species == species } ?? all[0]
    }
}
