import SwiftUI

struct MainTabView: View {
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            HeuteScreen()
                .tabItem { Label("tab.heute", systemImage: "scalemass.fill") }
                .tag(0)
            VogelScreen()
                .tabItem { Label("tab.voegel", systemImage: "bird.fill") }
                .tag(1)
            LogbuchScreen()
                .tabItem { Label("tab.logbuch", systemImage: "book.fill") }
                .tag(2)
            TrainingScreen()
                .tabItem { Label("tab.training", systemImage: "figure.run") }
                .tag(3)
            SettingsScreen()
                .tabItem { Label("tab.einstellungen", systemImage: "gearshape.fill") }
                .tag(4)
        }
        .tint(Palette.accent)
    }
}
