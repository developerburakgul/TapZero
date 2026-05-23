//
//  DeepLinkComponent.swift
//  TapZero
//

import Foundation

/// A single segment in a URL path pattern.
///
/// Components are the building blocks of a ``DeepLinkTemplate``.
/// Each component matches one segment of a URL path.
///
/// ```swift
/// // URL: tapzero://profile/42
/// //       ↑ term      ↑ string
/// ```
enum DeepLinkComponent: Sendable {
    /// Matches a fixed literal segment.
    ///
    /// `.term("profile")` matches the exact string `"profile"` (case-insensitive).
    case term(String)

    /// Captures any string segment and binds it to a named parameter.
    ///
    /// `.string(named: "userId")` captures `"abc"` as `["userId": "abc"]`.
    case string(named: String)

    /// Captures an integer-only segment and binds it to a named parameter.
    ///
    /// `.int(named: "page")` captures `"3"` as `["page": "3"]`, rejects `"abc"`.
    case int(named: String)
}
