import SwiftUI

enum Palette {
    static let accent = Color("AccentColor")
    static let accentSoft = Color("AccentColor").opacity(0.14)
    static var cardFill: Color { Color(uiColor: .secondarySystemGroupedBackground) }
    static var chipFill: Color { Color(uiColor: .tertiarySystemFill) }
    static var canvas: Color { Color(uiColor: .systemGroupedBackground) }
    static let leather = Color(red: 0.36, green: 0.22, blue: 0.13)
    static let brass = Color(red: 0.76, green: 0.62, blue: 0.30)
    static let bordeaux = Color(red: 0.52, green: 0.15, blue: 0.18)
    static let mossGreen = Color(red: 0.35, green: 0.45, blue: 0.28)
}
