import SwiftUI

struct SpeciesDetailView: View {
    let profile: SpeciesProfile

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(LocalizedStringKey(profile.species.nameKey))
                    .font(.system(.largeTitle, design: .serif).weight(.bold))
                Text(profile.species.latinName)
                    .font(.system(.headline, design: .serif).italic())
                    .foregroundStyle(.secondary)
                RoundedCard {
                    Text(LocalizedStringKey(profile.habitatKey))
                        .font(.body)
                }
            }
            .padding(16)
        }
        .background(FieldCanvas(opacity: 0.32, imageName: FieldBackdrop.named(for: profile.species)))
    }
}
