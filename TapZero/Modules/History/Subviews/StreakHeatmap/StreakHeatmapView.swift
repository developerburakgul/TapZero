//
//  StreakHeatmapView.swift
//  TapZero
//

import SwiftUI

extension HistoryScreen {
    struct StreakHeatmapView: View, Equatable {
        @Binding var binding: StreakHeatmapEntity.Binding
        let config: StreakHeatmapEntity.Config
        private let constants = Constants()

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config && lhs.binding == rhs.binding
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                headerRow
                heatmapGrid
            }
            .padding(.horizontal, constants.sectionPadding)
            .padding(.vertical, constants.sectionPaddingVertical)
            .background(TapZeroDesign.Background.card)
            .clipShape(RoundedRectangle(cornerRadius: constants.sectionCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: constants.sectionCornerRadius)
                    .stroke(TapZeroDesign.Hairline.default, lineWidth: 0.5)
            )
        }

        // MARK: - Header

        private var headerRow: some View {
            HStack(alignment: .firstTextBaseline) {
                Text(TextKey.History.streakLast14Days)
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1.2)
                    .textCase(.uppercase)
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)

                Spacer()

                if config.currentStreak > 0 {
                    Text(TextKey.History.streakDays(config.currentStreak))
                        .font(.system(size: 12, weight: .bold))
                        .tracking(-0.1)
                        .foregroundStyle(TapZeroDesign.Status.good)
                }
            }
            .padding(.bottom, constants.headerBottomPadding)
        }

        // MARK: - Heatmap Grid

        private var heatmapGrid: some View {
            HStack(spacing: constants.cellSpacing) {
                ForEach(config.days) { day in
                    VStack(spacing: constants.dayLabelSpacing) {
                        heatCell(gamesPlayed: day.gamesPlayed)

                        Text(day.dayLabel)
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundStyle(TapZeroDesign.Foreground.tertiary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }

        private func heatCell(gamesPlayed: Int) -> some View {
            let maxGames = max(config.maxGamesInDay, 1)

            return RoundedRectangle(cornerRadius: constants.cellCornerRadius)
                .fill(cellFill(gamesPlayed: gamesPlayed, maxGames: maxGames))
                .frame(height: constants.cellHeight)
                .overlay(
                    gamesPlayed == 0
                        ? RoundedRectangle(cornerRadius: constants.cellCornerRadius)
                            .stroke(TapZeroDesign.Hairline.default, lineWidth: 0.5)
                        : nil
                )
        }

        private func cellFill(gamesPlayed: Int, maxGames: Int) -> Color {
            if gamesPlayed == 0 {
                return TapZeroDesign.History.heatmapEmpty
            }
            let fraction = Double(gamesPlayed) / Double(maxGames)
            let opacity = 0.20 + fraction * 0.75
            return TapZeroDesign.History.heatmapHigh.opacity(opacity)
        }
    }
}

// MARK: - Previews

#Preview("Streak Heatmap") {
    let days: [HistoryScreen.StreakHeatmapEntity.HeatmapDay] = [
        .init(id: "d1", dayLabel: "M", gamesPlayed: 0),
        .init(id: "d2", dayLabel: "T", gamesPlayed: 2),
        .init(id: "d3", dayLabel: "W", gamesPlayed: 5),
        .init(id: "d4", dayLabel: "T", gamesPlayed: 3),
        .init(id: "d5", dayLabel: "F", gamesPlayed: 0),
        .init(id: "d6", dayLabel: "S", gamesPlayed: 1),
        .init(id: "d7", dayLabel: "S", gamesPlayed: 4),
        .init(id: "d8", dayLabel: "M", gamesPlayed: 6),
        .init(id: "d9", dayLabel: "T", gamesPlayed: 0),
        .init(id: "d10", dayLabel: "W", gamesPlayed: 1),
        .init(id: "d11", dayLabel: "T", gamesPlayed: 0),
        .init(id: "d12", dayLabel: "F", gamesPlayed: 2),
        .init(id: "d13", dayLabel: "S", gamesPlayed: 3),
        .init(id: "d14", dayLabel: "S", gamesPlayed: 0)
    ]

    HistoryScreen.StreakHeatmapView(
        binding: .constant(.init()),
        config: .init(days: days, currentStreak: 7, maxGamesInDay: 6)
    )
    .padding(.horizontal, 20)
    .background(TapZeroDesign.Background.primary)
}
