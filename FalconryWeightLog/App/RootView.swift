import SwiftUI

struct RootView: View {
    @AppStorage("fw.onboarding.seen") private var onboardingSeen = false

    var body: some View {
        MewsLaunchScaffold {
            if onboardingSeen {
                MainTabView()
            } else {
                OnboardingFlow()
            }
        }
    }
}
