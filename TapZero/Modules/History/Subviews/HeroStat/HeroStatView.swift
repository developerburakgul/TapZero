//
//  HeroStatView.swift
//  TapZero
//

import SwiftUI

extension HistoryScreen {
    struct HeroStatView: View, Equatable {
        @Binding var binding: HeroStatEntity.Binding
        let config: HeroStatEntity.Config
        private let constants = Constants()

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config && lhs.binding == rhs.binding
        }

        var body: some View {
            HStack(alignment: .bottom) {
                leftSection
                Spacer()
                if config.trendPercentage != nil {
                    rightSection
                }
            }
            .padding(.horizontal, constants.horizontalPadding)
            .padding(.top, constants.topPadding)
            .padding(.bottom, constants.bottomPadding)
            .background(TapZeroDesign.Foreground.primary)
            .clipShape(RoundedRectangle(cornerRadius: constants.cornerRadius))
        }

        // MARK: - Left

        private var leftSection: some View {
            VStack(alignment: .leading, spacing: 0) {
                heroLabel(TextKey.History.statAverageScore)

                Text("\(config.averageScore)")
                    .font(.system(size: 48, weight: .bold))
                    .tracking(-2)
                    .foregroundStyle(TapZeroDesign.Background.primary)
                    .padding(.top, 4)

                Text(TextKey.History.heroAcrossGames(config.totalGames))
                    .font(.system(size: 12, weight: .medium))
                    .tracking(-0.1)
                    .foregroundStyle(TapZeroDesign.Background.primary.opacity(0.7))
                    .padding(.top, 6)
            }
        }

        // MARK: - Right

        private var rightSection: some View {
            VStack(alignment: .trailing, spacing: 0) {
                heroLabel(TextKey.History.heroTrend)

                if let trend = config.trendPercentage {
                    let arrow = config.trendIsPositive ? "↑" : "↓"
                    let pct = String(format: "%.0f", abs(trend))
                    Text(TextKey.History.heroTrendValue(arrow: arrow, percentage: pct))
                        .font(.system(size: 18, weight: .bold))
                        .tracking(-0.4)
                        .foregroundStyle(
                            config.trendIsPositive
                                ? TapZeroDesign.Status.good
                                : TapZeroDesign.Status.bad
                        )
                        .padding(.top, 4)
                }
            }
        }

        private func heroLabel(_ text: LocalizedStringKey) -> some View {
            Text(text)
                .font(.system(size: 11, weight: .bold))
                .tracking(constants.labelLetterSpacing)
                .textCase(.uppercase)
                .foregroundStyle(TapZeroDesign.Background.primary.opacity(0.6))
        }

        private func heroLabel(_ text: String) -> some View {
            Text(text)
                .font(.system(size: 11, weight: .bold))
                .tracking(constants.labelLetterSpacing)
                .textCase(.uppercase)
                .foregroundStyle(TapZeroDesign.Background.primary.opacity(0.6))
        }
    }
}

// MARK: - Previews

#Preview("Hero — With Trend") {
    HistoryScreen.HeroStatView(
        binding: .constant(.init()),
        config: .init(averageScore: 542, totalGames: 60, trendPercentage: 12, trendIsPositive: true)
    )
    .padding(.horizontal, 20)
    .background(TapZeroDesign.Background.primary)
}

#Preview("Hero — No Trend") {
    HistoryScreen.HeroStatView(
        binding: .constant(.init()),
        config: .init(averageScore: 650, totalGames: 5, trendPercentage: nil, trendIsPositive: true)
    )
    .padding(.horizontal, 20)
    .background(TapZeroDesign.Background.primary)
}
