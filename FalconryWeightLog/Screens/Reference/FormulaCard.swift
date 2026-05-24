import SwiftUI

struct AlmanachCard: View {
    let titleKey: LocalizedStringKey
    let bodyKey: LocalizedStringKey
    let symbol: String

    var body: some View {
        RoundedCard {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: symbol)
                    .foregroundStyle(Palette.bordeaux)
                    .frame(width: 32, height: 32)
                    .background(Palette.brass.opacity(0.18), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                VStack(alignment: .leading, spacing: 4) {
                    Text(titleKey).font(.system(.headline, design: .serif).weight(.bold))
                    Text(bodyKey)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}
