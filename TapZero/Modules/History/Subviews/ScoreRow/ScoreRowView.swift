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
            lhs.config == rhs.config && lhs.binding == rhs.binding
        }

        var body: some View {
            HStack(spacing: constants.rowSpacing) {
                scoreGauge
                metaSection
                Spacer(minLength: 0)
            }
            .padding(.leading, constants.rowLeadingPadding)
            .padding(.trailing, constants.rowTrailingPadding)
            .padding(.vertical, constants.rowVerticalPadding)
            .background(TapZeroDesign.Background.card)
            .clipShape(RoundedRectangle(cornerRadius: constants.rowCornerRadius))
        }

        // MARK: - Score Gauge

        private var scoreGauge: some View {
            let ringSize = constants.discSize - constants.trackWidth
            return ZStack {
                Circle()
                    .fill(config.discSoftBackground)

                Circle()
                    .stroke(
                        config.discColor.opacity(constants.trackOpacity),
                        lineWidth: constants.trackWidth
                    )
                    .frame(width: ringSize, height: ringSize)

                Circle()
                    .trim(from: 0, to: CGFloat(config.score) / 1000.0)
                    .stroke(
                        config.discColor,
                        style: StrokeStyle(lineWidth: constants.trackWidth, lineCap: .round)
                    )
                    .frame(width: ringSize, height: ringSize)
                    .rotationEffect(.degrees(-90))

                Text("\(config.score)")
                    .font(.system(size: constants.scoreFontSize, weight: .bold))
                    .tracking(-0.3)
                    .monospacedDigit()
                    .foregroundStyle(scoreTextColor)
            }
            .frame(width: constants.discSize, height: constants.discSize)
        }

        private var scoreTextColor: Color {
            config.rating == .mid
                ? TapZeroDesign.Foreground.primary
                : config.discColor
        }

        // MARK: - Meta

        private var metaSection: some View {
            VStack(alignment: .leading, spacing: 3) {
                Text(config.dateFormatted)
                    .font(.system(size: 15, weight: .semibold))
                    .tracking(-0.2)
                    .monospacedDigit()
                    .foregroundStyle(TapZeroDesign.Foreground.primary)

                Text(config.subtitleFormatted)
                    .font(.system(size: 12, weight: .medium))
                    .tracking(-0.1)
                    .monospacedDigit()
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
            dateFormatted: "5s · 5.01s",
            subtitleFormatted: "Today · +0.01s"
        )
    )
    .padding(.horizontal, 20)
    .background(TapZeroDesign.Background.primary)
}

#Preview("Row — Good") {
    HistoryScreen.ScoreRowView(
        binding: .constant(.init()),
        config: .init(
            id: "2", score: 870, targetSeconds: 15,
            tappedSeconds: 14.78, delta: 0.22, rating: .good,
            discColor: TapZeroDesign.History.goodDisc,
            discSoftBackground: TapZeroDesign.Score.goodBackground,
            dateFormatted: "15s · 14.78s",
            subtitleFormatted: "Today · −0.22s"
        )
    )
    .padding(.horizontal, 20)
    .background(TapZeroDesign.Background.primary)
}

#Preview("Row — Mid") {
    HistoryScreen.ScoreRowView(
        binding: .constant(.init()),
        config: .init(
            id: "3", score: 720, targetSeconds: 10,
            tappedSeconds: 9.55, delta: 0.45, rating: .mid,
            discColor: TapZeroDesign.History.midDisc,
            discSoftBackground: TapZeroDesign.Score.neutralBackground,
            dateFormatted: "10s · 9.55s",
            subtitleFormatted: "Yesterday · −0.45s"
        )
    )
    .padding(.horizontal, 20)
    .background(TapZeroDesign.Background.primary)
}

#Preview("Row — Bad") {
    HistoryScreen.ScoreRowView(
        binding: .constant(.init()),
        config: .init(
            id: "4", score: 640, targetSeconds: 5,
            tappedSeconds: 4.0, delta: 1.0, rating: .bad,
            discColor: TapZeroDesign.History.badDisc,
            discSoftBackground: TapZeroDesign.Score.badBackground,
            dateFormatted: "5s · 4.00s",
            subtitleFormatted: "2d ago · −1.00s"
        )
    )
    .padding(.horizontal, 20)
    .background(TapZeroDesign.Background.primary)
}
