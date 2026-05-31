//
//  ScoreRowView.swift
//  TapZero
//

import SwiftUI

extension HistoryScreen {
    struct ScoreRowView: View, Equatable {
        @Binding var binding: ScoreRowEntity.Binding
        let config: ScoreRowEntity.Config
        private let constants = Constants()

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config
        }

        var body: some View {
            HStack(spacing: constants.rowSpacing) {
                scoreDisc
                metaSection
            }
            .padding(.leading, constants.rowLeadingPadding)
            .padding(.trailing, constants.rowTrailingPadding)
            .padding(.vertical, constants.rowVerticalPadding)
        }

        // MARK: - Score Disc

        private var scoreDisc: some View {
            Text("\(config.score)")
                .font(.system(size: constants.scoreFontSize, weight: .bold, design: .rounded))
                .tracking(-0.3)
                .monospacedDigit()
                .foregroundStyle(config.discColor)
                .frame(width: constants.discSize, height: constants.discSize)
                .fixedSize()
                .background(config.discSoftBackground)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(config.discColor.opacity(0.20), lineWidth: 1)
                )
                .shadow(color: config.discColor.opacity(0.10), radius: 1.5, x: 0, y: 0)
                .shadow(color: config.discColor.opacity(0.22), radius: 2, x: 0, y: 0)
        }

        // MARK: - Meta

        private var metaSection: some View {
            VStack(alignment: .leading, spacing: 3) {
                Text(config.dateFormatted)
                    .font(.system(size: 15, weight: .semibold))
                    .tracking(-0.2)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)

                Text(config.subtitleFormatted)
                    .font(.system(size: 12, weight: .medium))
                    .tracking(-0.1)
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)
            }
        }
    }
}

// MARK: - Previews

#Preview("Row — Perfect") {
    HistoryScreen.ScoreRowView(
        binding: .constant(.init()),
        config: .init(
            id: "1", score: 998, targetSeconds: 5,
            tappedSeconds: 5.01, delta: 0.01, rating: .perfect,
            discColor: TapZeroDesign.History.perfectDisc,
            discSoftBackground: TapZeroDesign.Score.goodBackground,
            dateFormatted: "2:34 PM",
            subtitleFormatted: "5s · 5.01s · +0.01s"
        )
    )
    .padding(.horizontal, 20)
    .background(TapZeroDesign.Background.primary)
}

#Preview("Row — Bad") {
    HistoryScreen.ScoreRowView(
        binding: .constant(.init()),
        config: .init(
            id: "2", score: 640, targetSeconds: 5,
            tappedSeconds: 4.0, delta: 1.0, rating: .bad,
            discColor: TapZeroDesign.History.badDisc,
            discSoftBackground: TapZeroDesign.Score.badBackground,
            dateFormatted: "May 27",
            subtitleFormatted: "5s · 4.00s · −1.00s"
        )
    )
    .padding(.horizontal, 20)
    .background(TapZeroDesign.Background.primary)
}

#Preview("Row — Mid") {
    HistoryScreen.ScoreRowView(
        binding: .constant(.init()),
        config: .init(
            id: "3", score: 780, targetSeconds: 10,
            tappedSeconds: 9.55, delta: 0.45, rating: .mid,
            discColor: TapZeroDesign.Foreground.secondary,
            discSoftBackground: TapZeroDesign.Score.neutralBackground,
            dateFormatted: "May 26",
            subtitleFormatted: "10s · 9.55s · −0.45s"
        )
    )
    .padding(.horizontal, 20)
    .background(TapZeroDesign.Background.primary)
}
