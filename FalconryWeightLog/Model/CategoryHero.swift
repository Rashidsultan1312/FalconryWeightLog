import Foundation

enum FieldBackdrop {
    static let names: [String] = [
        "Backdrops/bd-peregrine",
        "Backdrops/bd-goshawk",
        "Backdrops/bd-falcon-hood",
        "Backdrops/bd-gauntlet",
        "Backdrops/bd-brass-scale",
        "Backdrops/bd-jess-strap",
        "Backdrops/bd-perch",
        "Backdrops/bd-bell",
        "Backdrops/bd-crest",
        "Backdrops/bd-oak-leaf",
        "Backdrops/bd-feather",
        "Backdrops/bd-lure",
        "Backdrops/bd-beech-wood",
        "Backdrops/bd-hawking-bag"
    ]
    static let primary = "Backdrops/bd-gauntlet"
    static func named(for species: BirdSpecies) -> String {
        switch species {
        case .habicht: return "Backdrops/bd-goshawk"
        case .wanderfalke: return "Backdrops/bd-peregrine"
        case .sperber: return "Backdrops/bd-feather"
        case .steinadler: return "Backdrops/bd-crest"
        case .turmfalke: return "Backdrops/bd-bell"
        case .rotmilan: return "Backdrops/bd-lure"
        }
    }
}
