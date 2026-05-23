//
//  DeepLinkRoute.swift
//  TapZero
//

import Foundation

/// Binds a URL pattern to a destination.
///
/// A route pairs a ``DeepLinkTemplate`` with a handler that converts
/// extracted parameters into a destination value.
///
/// ```swift
/// DeepLinkRoute<AppRoute>(
///     template: DeepLinkTemplate()
///         .term("profile")
///         .string(named: "userId"),
///     handler: { params in
///         guard let id = params["userId"] else { return nil }
///         return .profile(userId: id)
///     }
/// )
/// ```
///
/// - Parameter Destination: The type that represents a navigation target in your app.
struct DeepLinkRoute<Destination> {
    let template: DeepLinkTemplate
    let handler: ([String: String]) -> Destination?
}
