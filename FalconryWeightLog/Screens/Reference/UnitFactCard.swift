import SwiftUI

struct SpeciesProfileCard: View {
    let profile: SpeciesProfile

    var body: some View {
        RoundedCard(tinted: profile.species.tint.opacity(0.10)) {
            VStack(alignment: .leading, spacing: 6) {
                Text(LocalizedStringKey(profile.species.nameKey))
                    .font(.system(.headline, design: .serif).weight(.bold))
                Text(profile.species.latinName)
                    .font(.system(.caption, design: .serif).italic())
                    .foregroundStyle(.secondary)
                Text(LocalizedStringKey(profile.temperamentKey))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
