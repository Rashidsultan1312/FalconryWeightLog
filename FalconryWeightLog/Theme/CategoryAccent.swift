import SwiftUI

enum FieldAccent {
    static func tint(for species: BirdSpecies) -> Color { species.tint }
    static func surface(for species: BirdSpecies) -> Color { species.tint.opacity(0.14) }
}
