//
//  TimelineBarView.swift
//  TapZero
//

import SwiftUI

extension GameResultScreen {
    struct TimelineBarView: View, Equatable {
        let config: TimelineBarEntity.Config
        let constants: ScoreCardView.Constants

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config
        }

        var body: some View {
            VStack(spacing: 4) {
                timeline
                labels
            }
        }

        // MARK: - Timeline

        private var timeline: some View {
            GeometryReader { geo in
                let width = geo.size.width
                let centerX = width / 2
                let userX = centerX + config.userOffset * width

                ZStack(alignment: .leading) {
                    // Track — gap at center dot so it doesn't bleed through
                    Capsule()
                        .fill(config.hairlineOverride ?? TapZeroDesign.Hairline.medium)
                        .frame(height: constants.timelineTrackHeight)
                        .frame(maxWidth: .infinity)
                        .mask(
                            HStack(spacing: 0) {
                                Rectangle()
                                Color.clear
                                    .frame(width: constants.timelineDotSize + 2)
                                Rectangle()
                            }
                        )

                    // Target dot (center)
                    targetDot
                        .position(x: centerX, y: 22)

                    // User dot
                    userDot
                        .position(x: userX, y: 22)
                }
            }
            .frame(height: 44)
        }

        private var targetDot: some View {
            let dotFill: Color = config.isPerfect
                ? config.scoreColor
                : (config.targetDotFillOverride ?? TapZeroDesign.Background.primary)
            let dotStroke: Color = config.isPerfect
                ? config.scoreColor
                : (config.foregroundOverride ?? TapZeroDesign.Foreground.primary)

            return Circle()
                .fill(dotFill)
                .frame(
                    width: constants.timelineDotSize,
                    height: constants.timelineDotSize
                )
                .overlay(
                    Circle()
                        .stroke(
                            dotStroke,
                            lineWidth: constants.timelineDotBorderWidth
                        )
                )
                .shadow(
                    color: config.isPerfect
                        ? config.scoreColor.opacity(0.3)
                        : .clear,
                    radius: 4
                )
        }

        private var userDot: some View {
            Circle()
                .fill(config.scoreColor)
                .frame(
                    width: constants.timelineDotSize,
                    height: constants.timelineDotSize
                )
                .shadow(color: config.scoreColor.opacity(0.3), radius: 4)
        }

        // MARK: - Labels

        private var labels: some View {
            let labelColor = config.foregroundOverride?.opacity(0.35)
                ?? TapZeroDesign.Foreground.tertiary
            let labelFont = Font.system(size: 11, weight: .medium)

            return HStack(spacing: 0) {
                Text(TextKey.GameResult.early)
                    .font(labelFont)
                    .tracking(0.6)
                    .textCase(.uppercase)
                    .foregroundStyle(labelColor)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(TextKey.GameResult.target)
                    .font(labelFont)
                    .tracking(0.6)
                    .textCase(.uppercase)
                    .foregroundStyle(labelColor)

                Text(TextKey.GameResult.late)
                    .font(labelFont)
                    .tracking(0.6)
                    .textCase(.uppercase)
                    .foregroundStyle(labelColor)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}
