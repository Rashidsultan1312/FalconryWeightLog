import SwiftUI

struct PrivacyWebView: View {
    var body: some View {
        LureFrame(bait: AppConfig.privacyPolicyURL, virgin: true)
            .navigationTitle("settings.privacy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
    }
}
