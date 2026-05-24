import SwiftUI

@main
struct FalconryWeightLogApp: App {
    @StateObject private var ledger = WeightLedger()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(ledger)
                .preferredColorScheme(ledger.appearance.colorScheme)
                .tint(Palette.accent)
        }
    }
}
