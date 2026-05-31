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
            lhs.config == rhs.config && lhs.binding == rhs.binding
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

                Text(TextKey.History.gameCount(config.gameCount))
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

private struct DaySectionPreviewContainer: View {
    var rows: [HistoryScreen.ScoreRowEntity.Config] {
        [
            .init(
                id: "1", score: 998, targetSeconds: 5,
                tappedSeconds: 5.01, delta: 0.01, rating: .perfect,
                discColor: TapZeroDesign.History.perfectDisc,
                discSoftBackground: TapZeroDesign.Score.goodBackground,
                dateFormatted: "5s · 5.01s",
                subtitleFormatted: "Today · +0.01s"
            ),
            .init(
                id: "2", score: 870, targetSeconds: 15,
                tappedSeconds: 14.78, delta: 0.22, rating: .good,
                discColor: TapZeroDesign.History.goodDisc,
                discSoftBackground: TapZeroDesign.Score.goodBackground,
                dateFormatted: "15s · 14.78s",
                subtitleFormatted: "Today · −0.22s"
            ),
            .init(
                id: "3", score: 720, targetSeconds: 10,
                tappedSeconds: 9.55, delta: 0.45, rating: .mid,
                discColor: TapZeroDesign.History.midDisc,
                discSoftBackground: TapZeroDesign.Score.neutralBackground,
                dateFormatted: "10s · 9.55s",
                subtitleFormatted: "Today · −0.45s"
            )
        ]
    }

    var body: some View {
        HistoryScreen.DaySectionView(
            binding: .constant(.init()),
            config: .init(id: "today", dateLabel: "Today", gameCount: 3, rows: rows)
        )
        .padding(.horizontal, 20)
        .background(TapZeroDesign.Background.primary)
    }
}

#Preview("Day Section — Today") {
    DaySectionPreviewContainer()
}
