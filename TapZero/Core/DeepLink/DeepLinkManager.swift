//
//  DeepLinkManager.swift
//  TapZero
//

import Foundation

@MainActor
final class DeepLinkManager {
    private(set) var pendingDeepLink: DeepLink?
    private var continuation: AsyncStream<DeepLink>.Continuation?

    private let recognizer = DeepLinkRecognizer<DeepLink>(
        scheme: "tapzero",
        universalLinkPrefix: "tapzero",
        routes: [
            DeepLinkRoute(template: DeepLinkTemplate().term("play")) { _ in .tab(.play) },
            DeepLinkRoute(template: DeepLinkTemplate().term("leaderboard")) { _ in .tab(.leaderBoard) },
            DeepLinkRoute(template: DeepLinkTemplate().term("history")) { _ in .tab(.history) },
            DeepLinkRoute(template: DeepLinkTemplate().term("settings")) { _ in .tab(.settings) }
        ]
    )

    lazy var deepLinks: AsyncStream<DeepLink> = {
        AsyncStream { [weak self] continuation in
            self?.continuation = continuation
        }
    }()

    func handleURL(_ url: URL) {
        guard let deepLink = recognizer.recognize(url) else { return }
        pendingDeepLink = deepLink
        continuation?.yield(deepLink)
    }

    func consume() -> DeepLink? {
        defer { pendingDeepLink = nil }
        return pendingDeepLink
    }
}
