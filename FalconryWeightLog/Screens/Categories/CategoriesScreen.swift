import SwiftUI

struct TrainingScreen: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(TrainingExerciseCatalog.all) { ex in
                        ExerciseCard(exercise: ex)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            .background(FieldCanvas(opacity: 0.32, imageName: "Backdrops/bd-lure"))
            .navigationTitle("tab.training")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
