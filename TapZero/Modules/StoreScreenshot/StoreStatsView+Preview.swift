//
//  StoreStatsView+Preview.swift
//  TapZero
//

import SwiftUI

// MARK: - Stats Showcase

private struct StoreStatsShowcase: View {
    let localeData: StoreLocaleData

    var body: some View {
        ZStack {
            TapZeroDesign.Background.primary.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    heroStat
                    kpiGrid
                    distribution
                }
                .padding(.horizontal, 20)
                .padding(.top, 32)
                .padding(.bottom, 20)
            }
        }
    }

    // MARK: - Hero Stat

    private var heroStat: some View {
        HistoryScreen.HeroStatView(
            binding: .constant(.init()),
            config: .init(
                averageScore: 724,
                totalGames: 42,
                trendPercentage: 12,
                trendIsPositive: true
            )
        )
        .scaleEffect(1.12)
        .padding(.vertical, 8)
    }

    // MARK: - KPI Grid

    private var kpiGrid: some View {
        HistoryScreen.KPIGridView(
            binding: .constant(.init()),
            config: .init(
                bestRoundScore: 986,
                bestRoundDate: "2 days ago",
                bestStreak: 18,
                perfectCount: 23,
                totalGames: 60,
                perfectPercentage: 38,
                avgOffBy: "0.34s"
            )
        )
    }

    // MARK: - Distribution

    private var distribution: some View {
        HistoryScreen.DistributionView(
            binding: .constant(.init()),
            config: .init(segments: [
                .init(
                    id: "perfect", rating: .perfect, count: 5,
                    percentage: 25, color: TapZeroDesign.History.perfectDisc
                ),
                .init(
                    id: "good", rating: .good, count: 8,
                    percentage: 40, color: TapZeroDesign.History.goodDisc
                ),
                .init(
                    id: "mid", rating: .mid, count: 4,
                    percentage: 20, color: TapZeroDesign.History.midDisc
                ),
                .init(
                    id: "bad", rating: .bad, count: 3,
                    percentage: 15, color: TapZeroDesign.History.badDisc
                )
            ])
        )
    }
}

// MARK: - Previews (10 Locales)

#Preview("Store Stats — EN") {
    StoreLocalePreview(storeLocales[0]) { StoreStatsShowcase(localeData: storeLocales[0]) }
}
#Preview("Store Stats — TR") {
    StoreLocalePreview(storeLocales[1]) { StoreStatsShowcase(localeData: storeLocales[1]) }
}
#Preview("Store Stats — AR") {
    StoreLocalePreview(storeLocales[2]) { StoreStatsShowcase(localeData: storeLocales[2]) }
}
#Preview("Store Stats — DE") {
    StoreLocalePreview(storeLocales[3]) { StoreStatsShowcase(localeData: storeLocales[3]) }
}
#Preview("Store Stats — ES") {
    StoreLocalePreview(storeLocales[4]) { StoreStatsShowcase(localeData: storeLocales[4]) }
}
#Preview("Store Stats — FR") {
    StoreLocalePreview(storeLocales[5]) { StoreStatsShowcase(localeData: storeLocales[5]) }
}
#Preview("Store Stats — IT") {
    StoreLocalePreview(storeLocales[6]) { StoreStatsShowcase(localeData: storeLocales[6]) }
}
#Preview("Store Stats — JA") {
    StoreLocalePreview(storeLocales[7]) { StoreStatsShowcase(localeData: storeLocales[7]) }
}
#Preview("Store Stats — KO") {
    StoreLocalePreview(storeLocales[8]) { StoreStatsShowcase(localeData: storeLocales[8]) }
}
#Preview("Store Stats — PT-BR") {
    StoreLocalePreview(storeLocales[9]) { StoreStatsShowcase(localeData: storeLocales[9]) }
}
