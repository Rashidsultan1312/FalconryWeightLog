import Foundation

enum WeightStatus {
    case low
    case nearTarget
    case onTarget
    case high

    var titleKey: String {
        switch self {
        case .low:        return "status.low"
        case .nearTarget: return "status.near"
        case .onTarget:   return "status.on"
        case .high:       return "status.high"
        }
    }

    var hueValue: Double {
        switch self {
        case .low:        return 0.62
        case .nearTarget: return 0.10
        case .onTarget:   return 0.34
        case .high:       return 0.00
        }
    }
}

enum FeedRecommender {
    static func status(for bird: Bird, currentGrams: Int) -> WeightStatus {
        let delta = currentGrams - bird.flyingWeight
        let tolerance = bird.weightTolerance
        if delta < -tolerance { return .low }
        if delta > tolerance * 3 { return .high }
        if abs(delta) <= tolerance { return .onTarget }
        return .nearTarget
    }

    static func recommendedFeedGrams(for bird: Bird, currentGrams: Int) -> Int {
        let delta = currentGrams - bird.flyingWeight
        let base = Double(bird.species.baseRation)
        let adjusted = base - Double(delta) * 0.45
        return max(0, Int(adjusted.rounded()))
    }

    static func recommendedFeed(_ feed: FeedKind, gramsAt nativeBeef: Int) -> Int {
        Int((Double(nativeBeef) / feed.caloryDensity).rounded())
    }
}
