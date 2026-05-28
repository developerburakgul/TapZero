//
//  LanguageManager.swift
//  Created by __Username__ on __Date__
//

import Combine
import Foundation
import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable, Sendable {
    case arabic              = "ar"
    case english             = "en"
    case french              = "fr"
    case german              = "de"
    case italian             = "it"
    case japanese            = "ja"
    case korean              = "ko"
    case portugueseBrazil    = "pt-BR"
    case spanish             = "es"
    case turkish             = "tr"

    var id: String { rawValue }

    /// Her dil kendi dilinde gösterilir (English, Türkçe, Español …)
    var nativeDisplayName: String {
        let locale = Locale(identifier: rawValue)
        return locale.localizedString(forLanguageCode: rawValue)?.localizedCapitalized ?? rawValue
    }

    /// İngilizce karşılığı (German, Turkish, Spanish …)
    var englishDisplayName: String {
        Locale(identifier: "en").localizedString(forLanguageCode: rawValue)?.localizedCapitalized ?? rawValue
    }

    var flagEmoji: String {
        switch self {
        case .arabic: "🇸🇦"
        case .english: "🇺🇸"
        case .french: "🇫🇷"
        case .german: "🇩🇪"
        case .italian: "🇮🇹"
        case .japanese: "🇯🇵"
        case .korean: "🇰🇷"
        case .portugueseBrazil: "🇧🇷"
        case .spanish: "🇪🇸"
        case .turkish: "🇹🇷"
        }
    }
}

final class LanguageManager: ObservableObject {
    private let key = "selectedLanguage"

    @Published var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: key)
        }
    }

    /// App language + device region.
    /// e.g. language = ar, device region = SA → Locale("ar_SA")
    var locale: Locale {
        let lang = currentLanguage.rawValue
        let region = Locale.current.region?.identifier ?? ""
        if region.isEmpty {
            return Locale(identifier: lang)
        }
        return Locale(identifier: "\(lang)_\(region)")
    }

    init() {
        if let saved = UserDefaults.standard.string(forKey: key),
           let language = AppLanguage(rawValue: saved) {
            self.currentLanguage = language
        } else {
            let detected = Self.detectDeviceLanguage()
            self.currentLanguage = detected
            UserDefaults.standard.set(detected.rawValue, forKey: key)
        }
    }

    // MARK: - Device Language Detection

    private static func detectDeviceLanguage() -> AppLanguage {
        let allCases: [String: AppLanguage] = Dictionary(
            uniqueKeysWithValues: AppLanguage.allCases.map { ($0.rawValue, $0) }
        )

        let familyPreferences: [String: String] = [
            "pt": "pt-BR"
        ]

        for identifier in Locale.preferredLanguages {
            if let match = allCases[identifier] { return match }

            var components = identifier.components(separatedBy: "-")
            while components.count > 1 {
                components.removeLast()
                let shortened = components.joined(separator: "-")
                if let match = allCases[shortened] { return match }
            }

            let base = identifier.components(separatedBy: "-").first ?? identifier

            if let preferred = familyPreferences[base],
               let match = allCases[preferred] { return match }

            let family = allCases.filter {
                ($0.key.components(separatedBy: "-").first ?? $0.key) == base
            }
            if let plain = family[base] { return plain }
            if let closest = family.min(by: { $0.key < $1.key }) {
                return closest.value
            }
        }

        return .english
    }
}
