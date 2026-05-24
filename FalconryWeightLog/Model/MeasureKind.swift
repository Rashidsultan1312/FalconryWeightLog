import SwiftUI

enum BirdSpecies: String, CaseIterable, Codable, Identifiable {
    case habicht
    case wanderfalke
    case sperber
    case steinadler
    case turmfalke
    case rotmilan

    var id: String { rawValue }

    var nameKey: String { "species.\(rawValue).name" }
    var latinName: String {
        switch self {
        case .habicht:    return "Accipiter gentilis"
        case .wanderfalke:return "Falco peregrinus"
        case .sperber:    return "Accipiter nisus"
        case .steinadler: return "Aquila chrysaetos"
        case .turmfalke:  return "Falco tinnunculus"
        case .rotmilan:   return "Milvus milvus"
        }
    }
    var defaultFullWeight: Int {
        switch self {
        case .habicht:    return 1000
        case .wanderfalke:return 800
        case .sperber:    return 300
        case .steinadler: return 4500
        case .turmfalke:  return 200
        case .rotmilan:   return 1100
        }
    }
    var defaultFlyingWeight: Int { Int(Double(defaultFullWeight) * 0.92) }
    var baseRation: Int {
        switch self {
        case .habicht:    return 110
        case .wanderfalke:return 80
        case .sperber:    return 35
        case .steinadler: return 480
        case .turmfalke:  return 25
        case .rotmilan:   return 130
        }
    }
    var tint: Color {
        switch self {
        case .habicht:    return Color(red: 0.56, green: 0.42, blue: 0.30)
        case .wanderfalke:return Color(red: 0.36, green: 0.46, blue: 0.62)
        case .sperber:    return Color(red: 0.62, green: 0.52, blue: 0.42)
        case .steinadler: return Color(red: 0.42, green: 0.34, blue: 0.30)
        case .turmfalke:  return Color(red: 0.78, green: 0.52, blue: 0.30)
        case .rotmilan:   return Color(red: 0.60, green: 0.32, blue: 0.24)
        }
    }
}

enum FeedKind: String, CaseIterable, Codable, Identifiable {
    case chick
    case quail
    case rabbit
    case mouse
    case beef
    case dove

    var id: String { rawValue }
    var nameKey: String { "feed.\(rawValue)" }
    var caloryDensity: Double {
        switch self {
        case .chick:  return 1.2
        case .quail:  return 1.3
        case .rabbit: return 1.5
        case .mouse:  return 1.1
        case .beef:   return 1.6
        case .dove:   return 1.4
        }
    }
}

enum LogbookKind: String, CaseIterable, Codable, Identifiable {
    case weighing
    case feeding
    case training
    case flight
    case hunt
    case note

    var id: String { rawValue }
    var titleKey: String { "log.kind.\(rawValue)" }
    var symbol: String {
        switch self {
        case .weighing: return "scalemass.fill"
        case .feeding:  return "fork.knife"
        case .training: return "figure.run"
        case .flight:   return "wind"
        case .hunt:     return "target"
        case .note:     return "text.alignleft"
        }
    }
}
