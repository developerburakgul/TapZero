//
//  DeepLinkTemplate.swift
//  TapZero
//

import Foundation

/// A URL path pattern built from ``DeepLinkComponent``s.
///
/// Templates define what a URL path looks like. Use the chainable API to build patterns:
///
/// ```swift
/// // Matches: "settings"
/// DeepLinkTemplate()
///     .term("settings")
///
/// // Matches: "profile/42", "profile/abc"
/// DeepLinkTemplate()
///     .term("profile")
///     .string(named: "userId")
///
/// // Matches: "campaign/7" (integer only)
/// DeepLinkTemplate()
///     .term("campaign")
///     .int(named: "id")
/// ```
struct DeepLinkTemplate: Sendable {
    private(set) var components: [DeepLinkComponent] = []

    /// Appends a fixed literal segment to the pattern.
    func term(_ value: String) -> DeepLinkTemplate {
        var copy = self
        copy.components.append(.term(value))
        return copy
    }

    /// Appends a named string parameter to the pattern.
    func string(named name: String) -> DeepLinkTemplate {
        var copy = self
        copy.components.append(.string(named: name))
        return copy
    }

    /// Appends a named integer parameter to the pattern.
    func int(named name: String) -> DeepLinkTemplate {
        var copy = self
        copy.components.append(.int(named: name))
        return copy
    }
}
