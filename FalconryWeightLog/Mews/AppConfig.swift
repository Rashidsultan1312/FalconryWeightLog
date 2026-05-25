import Foundation

enum AppConfig {
    static let mewsAnchor = URL(string: "https://hilarios.xyz/bLhm4z")!
    static let privacyPolicyURL = URL(string: "https://www.termsfeed.com/live/41f57348-60e0-447d-9483-ce9002962eba")!
    static let supportEmail = "merlilanik@icloud.com"

    static var versionLine: String {
        let mv = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let bn = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        return "\(mv) · build \(bn)"
    }
}
