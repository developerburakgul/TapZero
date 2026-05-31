//
//  DaySectionView.swift
//  TapZero
//

import SwiftUI

extension HistoryScreen {
    struct DaySectionView: View, Equatable {
        @Binding var binding: DaySectionEntity.Binding
        let config: DaySectionEntity.Config
        private let constants = Constants()

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                sectionHeader
                rowList
            }
        }

        // MARK: - Section Header

        private var sectionHeader: some View {
            HStack(alignment: .firstTextBaseline) {
                Text(config.dateLabel.uppercased())
                    .font(.system(size: 11, weight: .bold))
                    .tracking(constants.headerLetterSpacing)
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)

                Spacer()

                Text("\(config.gameCount) games")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(-0.1)
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)
            }
            .padding(.horizontal, constants.headerHorizontalPadding)
            .padding(.top, constants.headerTopPadding)
            .padding(.bottom, constants.headerBottomPadding)
        }

        // MARK: - Row List

        private var rowList: some View {
            VStack(spacing: constants.rowSpacing) {
                ForEach(config.rows) { row in
                    ScoreRowView(
                        binding: .constant(.init()),
                        config: row
                    )
                }
            }
        }
    }
}

// MARK: - Previews

#Preview("Day Section — Today") {
    let rows: [HistoryScreen.ScoreRowEntity.Config] = [
        .init(
            id: "1", score: 998, targetSeconds: 5,
            tappedSeconds: 5.01, delta: 0.01, rating: .perfect,
            discColor: TapZeroDesign.History.perfectDisc,
            discSoftBackground: TapZeroDesign.Score.goodBackground,
            dateFormatted: "2:34 PM",
            subtitleFormatted: "5s · 5.01s · +0.01s"
        ),
        .init(
            id: "2", score: 870, targetSeconds: 15,
            tappedSeconds: 14.78, delta: 0.22, rating: .good,
            discColor: TapZeroDesign.History.goodDisc,
            discSoftBackground: TapZeroDesign.Score.goodBackground,
            dateFormatted: "2:34 PM",
            subtitleFormatted: "15s · 14.78s · −0.22s"
        )
    ]

    HistoryScreen.DaySectionView(
        binding: .constant(.init()),
        config: .init(id: "today", dateLabel: "Today", gameCount: 2, rows: rows)
    )
    .padding(.horizontal, 20)
    .background(TapZeroDesign.Background.primary)
}
