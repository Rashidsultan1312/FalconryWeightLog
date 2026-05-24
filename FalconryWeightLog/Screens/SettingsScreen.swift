import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject private var ledger: WeightLedger
    @Environment(\.openURL) private var openURL
    @State private var confirmWipe = false

    var body: some View {
        NavigationStack {
            Form {
                Section("settings.section.preferences") {
                    Picker("settings.unit", selection: $ledger.weightUnit) {
                        ForEach(WeightUnit.allCases) { u in
                            Text(LocalizedStringKey(u.titleKey)).tag(u)
                        }
                    }
                    Picker("settings.appearance", selection: $ledger.appearance) {
                        ForEach(AppearanceMode.allCases) { m in
                            Text(m.label).tag(m)
                        }
                    }
                }
                Section("settings.section.data") {
                    HStack {
                        Label("settings.stats.birds", systemImage: "bird")
                        Spacer()
                        Text("\(ledger.birds.count)").foregroundStyle(.secondary)
                    }
                    HStack {
                        Label("settings.stats.entries", systemImage: "book")
                        Spacer()
                        Text("\(ledger.entries.count)").foregroundStyle(.secondary)
                    }
                    Button(role: .destructive) { confirmWipe = true } label: {
                        Label("settings.wipe", systemImage: "trash")
                    }
                    .disabled(ledger.entries.isEmpty)
                }
                Section("settings.section.about") {
                    Button {
                        if let url = supportMailURL() { openURL(url) }
                    } label: {
                        Label("settings.support", systemImage: "envelope")
                    }
                    .tint(.primary)
                    NavigationLink { PrivacyWebView() } label: {
                        Label("settings.privacy", systemImage: "hand.raised")
                    }
                    HStack {
                        Label("settings.version", systemImage: "info.circle")
                        Spacer()
                        Text(AppConfig.versionLine).foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("tab.einstellungen")
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("settings.wipe.confirm", isPresented: $confirmWipe, titleVisibility: .visible) {
                Button("settings.wipe", role: .destructive) {
                    if let bird = ledger.activeBird { ledger.wipeBirdData(bird) }
                }
                Button("action.cancel", role: .cancel) {}
            }
        }
    }

    private func supportMailURL() -> URL? {
        let subject = NSLocalizedString("support.subject", comment: "")
        var c = URLComponents()
        c.scheme = "mailto"
        c.path = AppConfig.supportEmail
        c.queryItems = [URLQueryItem(name: "subject", value: subject)]
        return c.url
    }
}
