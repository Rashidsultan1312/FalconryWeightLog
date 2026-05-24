import SwiftUI

struct MewsLaunchScaffold<Field: View>: View {
    @AppStorage("fw.mews.hooded") private var hooded = false
    @State private var beat: Beat = .casting
    @State private var openConsent = false
    @ViewBuilder var field: () -> Field

    var body: some View {
        Group {
            if hooded {
                field()
            } else {
                switch beat {
                case .casting:
                    ZStack {
                        Color(.systemGroupedBackground).ignoresSafeArea()
                        ProgressView()
                            .scaleEffect(1.25)
                    }
                    .task { await release() }
                case .stooped(let url):
                    LureFrame(bait: url, virgin: false)
                        .ignoresSafeArea()
                case .prompt:
                    Color(.systemGroupedBackground).ignoresSafeArea()
                        .fullScreenCover(isPresented: $openConsent) {
                            JessConsentPanel(bait: AppConfig.privacyPolicyURL) {
                                hooded = true
                                openConsent = false
                                beat = .quiet
                            }
                        }
                case .quiet:
                    field()
                }
            }
        }
    }

    @MainActor
    private func release() async {
        async let halt: Void = { try? await Task.sleep(nanoseconds: 1_900_000_000) }()
        async let call = MewsLedger.whistle()
        let outcome = await call
        _ = await halt
        switch outcome {
        case .stooped(let url):
            beat = .stooped(url)
        case .perched:
            beat = .prompt
            Task { @MainActor in openConsent = true }
        case .missed:
            beat = .quiet
        }
    }

    private enum Beat: Equatable {
        case casting
        case stooped(URL)
        case prompt
        case quiet
    }
}
