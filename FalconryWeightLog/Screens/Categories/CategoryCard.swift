import SwiftUI

struct ExerciseCard: View {
    let exercise: TrainingExercise

    var body: some View {
        RoundedCard {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Palette.brass.opacity(0.18))
                    Image(systemName: exercise.symbol)
                        .font(.title2)
                        .foregroundStyle(Palette.bordeaux)
                }
                .frame(width: 56, height: 56)
                VStack(alignment: .leading, spacing: 4) {
                    Text(LocalizedStringKey(exercise.titleKey))
                        .font(.system(.headline, design: .serif).weight(.bold))
                    Text(LocalizedStringKey(exercise.descriptionKey))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("\(exercise.durationMinutes) min")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Palette.accent)
                }
                Spacer(minLength: 0)
            }
        }
    }
}
