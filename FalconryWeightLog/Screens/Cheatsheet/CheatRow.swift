import SwiftUI

struct FieldStatBlock: View {
    let labelKey: LocalizedStringKey
    let value: String

    var body: some View {
        HStack {
            Text(labelKey).font(.subheadline)
            Spacer()
            Text(value).font(.system(.subheadline, design: .monospaced).weight(.semibold))
        }
    }
}
