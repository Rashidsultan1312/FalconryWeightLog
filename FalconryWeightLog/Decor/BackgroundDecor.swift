import SwiftUI

struct FieldCanvas: View {
    var opacity: Double = 0.55
    var imageName: String = FieldBackdrop.primary

    var body: some View {
        ZStack {
            Color(red: 0.98, green: 0.96, blue: 0.92)
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(opacity)
                .ignoresSafeArea()
            LinearGradient(colors: [Color.white.opacity(0.74), Color.white.opacity(0.82)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            LinearGradient(colors: [Palette.brass.opacity(0.06), Color.clear],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
}

struct FieldScrim: View {
    let species: BirdSpecies
    var body: some View {
        FieldAccent.tint(for: species).opacity(0.08).ignoresSafeArea()
    }
}
