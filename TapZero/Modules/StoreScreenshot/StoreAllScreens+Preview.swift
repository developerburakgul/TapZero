//
//  StoreAllScreens+Preview.swift
//  TapZero
//

import SwiftUI

// MARK: - Single Screen, All Locales (Swipeable)

@MainActor
private struct StoreLocaleCarousel<Content: View>: View {
    let builder: (StoreLocaleData) -> Content

    var body: some View {
        TabView {
            ForEach(Array(storeLocales.enumerated()), id: \.offset) { _, locale in
                StoreLocalePreview(locale) {
                    builder(locale)
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .statusBarHidden(true)
    }
}

// MARK: - Per-Screen Previews

#Preview("Gameplay — All Locales") {
    StoreLocaleCarousel { StoreGameplayShowcase(localeData: $0) }
}
#Preview("Scores — All Locales") {
    StoreLocaleCarousel { StoreScoresShowcase(localeData: $0) }
}
#Preview("Stats — All Locales") {
    StoreLocaleCarousel { StoreStatsShowcase(localeData: $0) }
}
#Preview("Share — All Locales") {
    StoreLocaleCarousel { StoreShareShowcase(localeData: $0) }
}
#Preview("LeaderBoard — All Locales") {
    StoreLocaleCarousel { StoreLeaderBoardShowcase(localeData: $0) }
}
#Preview("Play — All Locales") {
    StoreLocaleCarousel { StorePlayShowcase(localeData: $0) }
}
