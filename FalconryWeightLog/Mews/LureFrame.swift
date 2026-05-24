import SwiftUI
@preconcurrency import WebKit

struct LureFrame: View {
    let bait: URL
    var virgin: Bool = true
    @StateObject private var bridge = ProbeBridge()

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                LurePane(bait: bait, virgin: virgin, bridge: bridge)
                if bridge.loading && bridge.progress < 1.0 {
                    ProgressView(value: bridge.progress)
                        .progressViewStyle(.linear)
                        .tint(.white)
                }
            }
            HStack(spacing: 0) {
                navButton(systemImage: "chevron.left") { bridge.pane?.goBack() }
                navButton(systemImage: "chevron.right") { bridge.pane?.goForward() }
                navButton(systemImage: "arrow.clockwise") { bridge.pane?.reload() }
                navButton(systemImage: "house.fill") { bridge.pane?.load(URLRequest(url: bait)) }
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
        }
        .ignoresSafeArea(edges: .top)
    }

    private func navButton(systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 36)
        }
        .buttonStyle(.plain)
    }
}

@MainActor
private final class ProbeBridge: ObservableObject {
    @Published var loading = false
    @Published var progress: Double = 0
    weak var pane: WKWebView?
    private var observers: [NSKeyValueObservation] = []

    func attach(_ web: WKWebView) {
        pane = web
        observers = [
            web.observe(\.estimatedProgress, options: [.new]) { [weak self] view, _ in
                Task { @MainActor in self?.progress = view.estimatedProgress }
            },
            web.observe(\.isLoading, options: [.new]) { [weak self] view, _ in
                Task { @MainActor in self?.loading = view.isLoading }
            }
        ]
    }
}

private final class CleanWebView: WKWebView {
    override var inputAccessoryView: UIView? { nil }
}

private struct LurePane: UIViewRepresentable {
    let bait: URL
    var virgin: Bool
    var bridge: ProbeBridge

    func makeUIView(context: Context) -> WKWebView {
        let opt = WKWebViewConfiguration()
        opt.allowsInlineMediaPlayback = true
        opt.mediaTypesRequiringUserActionForPlayback = []
        opt.websiteDataStore = virgin ? .nonPersistent() : .default()
        let canvas = CleanWebView(frame: .zero, configuration: opt)
        canvas.allowsBackForwardNavigationGestures = true
        canvas.scrollView.bounces = true
        canvas.load(URLRequest(url: bait))
        DispatchQueue.main.async { bridge.attach(canvas) }
        return canvas
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
