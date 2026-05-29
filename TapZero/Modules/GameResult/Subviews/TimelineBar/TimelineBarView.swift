//
//  TimelineBarView.swift
//  TapZero
//

import SwiftUI

extension GameResultScreen {
    struct TimelineBarView: View, Equatable {
        let config: TimelineBarEntity.Config
        let constants: Constants

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
                        .position(x: centerX, y: 16)

                    // User dot
                    userDot
                        .position(x: userX, y: 16)
                }
            }
            .frame(height: 32)
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
            HStack {
                let labelColor = config.foregroundOverride?.opacity(0.35) ?? TapZeroDesign.Foreground.tertiary

                Text(TextKey.GameResult.early)
                    .font(.system(size: 11, weight: .medium))
                    .tracking(0.6)
                    .textCase(.uppercase)
                    .foregroundStyle(labelColor)

                Spacer()

                Text(config.targetLabel)
                    .font(.system(size: 11, weight: .medium))
                    .tracking(0.6)
                    .textCase(.uppercase)
                    .foregroundStyle(labelColor)

                Spacer()

                Text(TextKey.GameResult.late)
                    .font(.system(size: 11, weight: .medium))
                    .tracking(0.6)
                    .textCase(.uppercase)
                    .foregroundStyle(labelColor)
            }
        }
    }
}
