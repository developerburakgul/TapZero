//
//  TextKey.swift
//  Created by __Username__ on __Date__
//

import SwiftUI

enum TextKey {
    /// Resolves a localized string using the app's selected language.
    /// Use this instead of `String(localized:)` so alerts respect in-app language.
    static func localized(_ key: String.LocalizationValue) -> String {
        MainActor.assumeIsolated {
            let locale = Dependencies.shared.container.resolve(LanguageManager.self)?.locale ?? .current
            return String(localized: key, locale: locale)
        }
    }
}
