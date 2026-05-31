//
//  KPIGridView.swift
//  TapZero
//

import SwiftUI

extension HistoryScreen {
    struct KPIGridView: View, Equatable {
        @Binding var binding: KPIGridEntity.Binding
        let config: KPIGridEntity.Config
        private let constants = Constants()

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config && lhs.binding == rhs.binding
        }

        var body: some View {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: constants.gridSpacing),
                    GridItem(.flexible(), spacing: constants.gridSpacing)
                ],
                spacing: constants.gridSpacing
            ) {
                kpiCard(
                    label: TextKey.History.statBestRound,
                    value: "\(config.bestRoundScore)",
                    subtext: TextKey.History.kpiBestRoundSub(config.bestRoundDate)
                )
                kpiCard(
                    label: TextKey.History.statBestStreak,
                    value: "\(config.bestStreak)",
                    subtext: TextKey.History.kpiBestStreakSub
                )
                kpiCard(
                    label: TextKey.History.statPerfectRounds,
                    value: "\(config.perfectCount)",
                    subtext: TextKey.History.kpiPerfectSub(
                        total: config.totalGames,
                        percentage: String(format: "%.0f", config.perfectPercentage)
                    ),
                    accentColor: TapZeroDesign.Status.good
                )
                kpiCard(
                    label: TextKey.History.statAvgOffBy,
                    value: config.avgOffBy,
                    subtext: TextKey.History.kpiAvgOffBySub
                )
            }
        }

        private func kpiCard(
            label: LocalizedStringKey,
            value: String,
            subtext: LocalizedStringKey,
            accentColor: Color? = nil
        ) -> some View {
            VStack(alignment: .leading, spacing: constants.cardGap) {
                Text(label)
                    .font(.system(size: 11, weight: .bold))
                    .tracking(constants.labelLetterSpacing)
                    .textCase(.uppercase)
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)

                Text(value)
                    .font(.system(size: 26, weight: .bold))
                    .tracking(-0.8)
                    .lineLimit(1)
                    .foregroundStyle(accentColor ?? TapZeroDesign.Foreground.primary)

                Text(subtext)
                    .font(.system(size: 12, weight: .medium))
                    .tracking(-0.1)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, constants.cardPaddingH)
            .padding(.top, constants.cardPaddingTop)
            .padding(.bottom, constants.cardPaddingBottom)
            .background(TapZeroDesign.Background.card)
            .clipShape(RoundedRectangle(cornerRadius: constants.cardCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: constants.cardCornerRadius)
                    .stroke(TapZeroDesign.Hairline.default, lineWidth: 0.5)
            )
        }
    }
}

// MARK: - Previews

#Preview("KPI Grid") {
    HistoryScreen.KPIGridView(
        binding: .constant(.init()),
        config: .init(
            bestRoundScore: 912, bestRoundDate: "2 days ago",
            bestStreak: 18, perfectCount: 23,
            totalGames: 60, perfectPercentage: 38,
            avgOffBy: "0.34s"
        )
    )
    .padding(.horizontal, 20)
    .background(TapZeroDesign.Background.primary)
}
