//
//  DeepLinkRecognizer.swift
//  TapZero
//

import Foundation

/// Matches incoming URLs against registered routes and returns a destination.
///
/// The recognizer handles both custom URL schemes and Universal Links.
/// It extracts path segments from the URL, then tries each registered route
/// until one matches.
///
/// ```swift
/// let recognizer = DeepLinkRecognizer<AppRoute>(
///     scheme: "myapp",
///     universalLinkPrefix: "myapp",
///     routes: [
///         DeepLinkRoute(
///             template: DeepLinkTemplate().term("settings"),
///             handler: { _ in .settings }
///         ),
///         DeepLinkRoute(
///             template: DeepLinkTemplate().term("profile").string(named: "id"),
///             handler: { params in
///                 guard let id = params["id"] else { return nil }
///                 return .profile(id: id)
///             }
///         )
///     ]
/// )
///
/// let route = recognizer.recognize(url) // → AppRoute?
/// ```
///
/// - Parameter Destination: The type that represents a navigation target in your app.
struct DeepLinkRecognizer<Destination> {
    private let scheme: String
    private let universalLinkPrefix: String
    private let routes: [DeepLinkRoute<Destination>]

    init(
        scheme: String,
        universalLinkPrefix: String,
        routes: [DeepLinkRoute<Destination>]
    ) {
        self.scheme = scheme
        self.universalLinkPrefix = universalLinkPrefix
        self.routes = routes
    }

    /// Attempts to match a URL against registered routes.
    ///
    /// - Parameter url: The incoming URL from `.onOpenURL` or `UIApplicationDelegate`.
    /// - Returns: The matched destination, or `nil` if no route matches.
    func recognize(_ url: URL) -> Destination? {
        let segments = extractSegments(from: url)
        for route in routes {
            if let params = match(segments: segments, template: route.template) {
                return route.handler(params)
            }
        }
        return nil
    }
}

// MARK: - Segment Extraction

extension DeepLinkRecognizer {
    /// Extracts clean path segments from both URL Scheme and Universal Link formats.
    ///
    /// URL Scheme  : `myapp://profile/42`  → `["profile", "42"]`
    /// Universal   : `https://domain.com/myapp/profile/42` → `["profile", "42"]`
    private func extractSegments(from url: URL) -> [String] {
        if url.scheme == scheme {
            return schemeSegments(from: url)
        }
        return universalLinkSegments(from: url)
    }

    private func schemeSegments(from url: URL) -> [String] {
        var segments: [String] = []
        if let host = url.host() {
            segments.append(host)
        }
        segments.append(
            contentsOf: url.pathComponents.filter { $0 != "/" }
        )
        return segments
    }

    private func universalLinkSegments(from url: URL) -> [String] {
        let components = url.pathComponents.filter { $0 != "/" }
        guard let prefixIndex = components.firstIndex(of: universalLinkPrefix) else {
            return components
        }
        return Array(components.suffix(from: components.index(after: prefixIndex)))
    }
}

// MARK: - Template Matching

extension DeepLinkRecognizer {
    private func match(segments: [String], template: DeepLinkTemplate) -> [String: String]? {
        let components = template.components
        guard segments.count == components.count else { return nil }

        var params: [String: String] = [:]

        for (segment, component) in zip(segments, components) {
            switch component {
            case .term(let expected):
                guard segment.lowercased() == expected.lowercased() else { return nil }
            case .string(let name):
                params[name] = segment
            case .int(let name):
                guard Int(segment) != nil else { return nil }
                params[name] = segment
            }
        }
        return params
    }
}
