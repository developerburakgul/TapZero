//
//  StoreScreenshotCarousel.swift
//  TapZero
//

import DependencyContainer
import SwiftUI

// MARK: - Store Screenshot Carousel

/// Hangi ekranı çekmek istiyorsan aşağıdaki `screen`'i değiştir:
/// .gameplay, .scores, .stats, .share, .leaderBoard, .play
struct StoreScreenshotCarousel: View {
    private let screen: StoreScreen = .gameplay
    @State private var currentIndex = 0

    private var locale: StoreLocaleData {
        storeLocales[currentIndex]
    }

    var body: some View {
        StoreLocalePreview(locale) {
            screen.view(locale)
        }
        .id(currentIndex)
        .statusBarHidden(true)
        .onChange(of: currentIndex) { _, newValue in
            applyLocale(storeLocales[newValue])
        }
        .onAppear {
            applyLocale(locale)
        }
        .gesture(
            DragGesture(minimumDistance: 60, coordinateSpace: .global)
                .onEnded { value in
                    if value.translation.width < -60, currentIndex < storeLocales.count - 1 {
                        currentIndex += 1
                    } else if value.translation.width > 60, currentIndex > 0 {
                        currentIndex -= 1
                    }
                }
        )
    }

    private func applyLocale(_ data: StoreLocaleData) {
        guard let manager = Dependencies.shared.container.resolve(LanguageManager.self) else { return }
        manager.currentLanguage = data.language
        manager.localeOverride = Locale(identifier: data.localeIdentifier)
    }
}

// MARK: - Store Screen

private enum StoreScreen {
    case gameplay, scores, stats, share, leaderBoard, play

    @MainActor @ViewBuilder
    func view(_ locale: StoreLocaleData) -> some View {
        switch self {
        case .gameplay: StoreGameplayShowcase(localeData: locale)
        case .scores: StoreScoresShowcase(localeData: locale)
        case .stats: StoreStatsShowcase(localeData: locale)
        case .share: StoreShareShowcase(localeData: locale)
        case .leaderBoard: StoreLeaderBoardShowcase(localeData: locale)
        case .play: StorePlayShowcase(localeData: locale)
        }
    }
}
