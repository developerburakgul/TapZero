//
//  StoreScreenshotData.swift
//  TapZero
//

import SwiftUI

// MARK: - Locale Data

struct StoreLocaleData {
    let language: AppLanguage
    let localeIdentifier: String
    let userName: String
}

let storeLocales: [StoreLocaleData] = [
    .init(language: .english, localeIdentifier: "en_US", userName: "John"),
    .init(language: .turkish, localeIdentifier: "tr_TR", userName: "Burak"),
    .init(language: .arabic, localeIdentifier: "ar_SA", userName: "أحمد"),
    .init(language: .german, localeIdentifier: "de_DE", userName: "Lukas"),
    .init(language: .spanish, localeIdentifier: "es_ES", userName: "Carlos"),
    .init(language: .french, localeIdentifier: "fr_FR", userName: "Pierre"),
    .init(language: .italian, localeIdentifier: "it_IT", userName: "Marco"),
    .init(language: .japanese, localeIdentifier: "ja_JP", userName: "ユウキ"),
    .init(language: .korean, localeIdentifier: "ko_KR", userName: "지민"),
    .init(language: .portugueseBrazil, localeIdentifier: "pt_BR", userName: "Lucas")
]

// MARK: - Preview Wrapper

@MainActor
struct StoreLocalePreview<Content: View>: View {
    let data: StoreLocaleData
    let content: Content

    init(_ data: StoreLocaleData, @ViewBuilder content: () -> Content) {
        self.data = data
        self.content = content()
        DevPreview.shared.languageManager.currentLanguage = data.language
        DevPreview.shared.languageManager.localeOverride = Locale(identifier: data.localeIdentifier)
    }

    var body: some View {
        content
            .environment(\.locale, Locale(identifier: data.localeIdentifier))
            .environment(\.colorScheme, .light)
    }
}

// MARK: - Number Formatting

struct StoreNumberFormatter {
    let locale: Locale

    init(localeIdentifier: String) {
        self.locale = Locale(identifier: localeIdentifier)
    }

    func formatTime(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = locale
        return formatter.string(from: NSNumber(value: value)) ?? String(format: "%.2f", value)
    }
}
