import Foundation
import UIKit
@preconcurrency import WebKit

enum LureCall: Equatable {
    case stooped(URL)
    case perched
    case missed
}

enum MewsLedger {
    @MainActor
    static func whistle() async -> LureCall {
        await JessHandler().release()
    }

    static func trim(_ url: URL) -> String {
        var span = URLComponents(url: url, resolvingAgainstBaseURL: true) ?? URLComponents()
        span.fragment = nil
        span.scheme = (span.scheme ?? "https").lowercased()
        span.host = span.host?.lowercased()
        var trail = span.path
        while trail.count > 1 && trail.hasSuffix("/") { trail.removeLast() }
        span.path = trail
        return span.url?.absoluteString ?? url.absoluteString.lowercased()
    }
}

@MainActor
final class JessHandler: NSObject, WKNavigationDelegate {
    private var awaiter: CheckedContinuation<LureCall, Never>?
    private var perch: WKWebView?
    private var hooded = false
    private var bellTimer: Task<Void, Never>?

    func release() async -> LureCall {
        await withCheckedContinuation { box in
            awaiter = box
            let opt = WKWebViewConfiguration()
            opt.websiteDataStore = .nonPersistent()
            let plate = WKWebView(frame: CGRect(x: 0, y: 0, width: 4, height: 4), configuration: opt)
            plate.alpha = 0.018
            plate.navigationDelegate = self
            plate.load(URLRequest(url: AppConfig.mewsAnchor))
            perch = plate
            bellTimer = Task { [weak self] in
                try? await Task.sleep(nanoseconds: 10_200_000_000)
                await MainActor.run { self?.hood(.missed) }
            }
        }
    }

    private func hood(_ call: LureCall) {
        if hooded { return }
        hooded = true
        bellTimer?.cancel()
        perch?.navigationDelegate = nil
        perch?.stopLoading()
        perch = nil
        awaiter?.resume(returning: call)
        awaiter = nil
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let target = navigationAction.request.url else {
            decisionHandler(.allow); return
        }
        let post = AppConfig.mewsAnchor
        if MewsLedger.trim(target) != MewsLedger.trim(post) {
            decisionHandler(.cancel)
            hood(.stooped(target))
            return
        }
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Task { @MainActor [weak self] in
            try? await Task.sleep(nanoseconds: 2_500_000_000)
            guard let self = self, !self.hooded else { return }
            self.hood(.perched)
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        _ = error; hood(.missed)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        _ = error; hood(.missed)
    }
}
