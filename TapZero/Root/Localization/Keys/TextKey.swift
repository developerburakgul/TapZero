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
            let manager = Dependencies.shared.container.resolve(LanguageManager.self)
            let locale = manager?.locale ?? .current
            let langCode = manager?.currentLanguage.rawValue ?? "en"
            let bundle: Bundle = Bundle.main.path(forResource: langCode, ofType: "lproj")
                .flatMap { Bundle(path: $0) } ?? .main
            return String(localized: key, bundle: bundle, locale: locale)
        }
    }

    /// Formats a number using the app's locale (language + device region).
    /// Produces locale-native digits (e.g. Arabic ٥ on SA devices).
    static func number(_ value: Int) -> String {
        MainActor.assumeIsolated {
            let locale = Dependencies.shared.container.resolve(LanguageManager.self)?.locale ?? .current
            return value.formatted(.number.grouping(.never).locale(locale))
        }
    }
}
