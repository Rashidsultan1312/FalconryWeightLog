import Foundation

struct TrainingExercise: Identifiable, Hashable {
    var id: String { titleKey }
    let titleKey: String
    let descriptionKey: String
    let symbol: String
    let durationMinutes: Int
}

enum TrainingExerciseCatalog {
    static let all: [TrainingExercise] = [
        .init(titleKey: "training.federspiel.title",
              descriptionKey: "training.federspiel.body",
              symbol: "wind",
              durationMinutes: 15),
        .init(titleKey: "training.beizjagd.title",
              descriptionKey: "training.beizjagd.body",
              symbol: "target",
              durationMinutes: 45),
        .init(titleKey: "training.faust.title",
              descriptionKey: "training.faust.body",
              symbol: "hand.raised.fill",
              durationMinutes: 20),
        .init(titleKey: "training.sprung.title",
              descriptionKey: "training.sprung.body",
              symbol: "arrow.up.right",
              durationMinutes: 10),
        .init(titleKey: "training.atzung.title",
              descriptionKey: "training.atzung.body",
              symbol: "leaf.fill",
              durationMinutes: 30),
        .init(titleKey: "training.kreis.title",
              descriptionKey: "training.kreis.body",
              symbol: "arrow.triangle.2.circlepath",
              durationMinutes: 25)
    ]
}
