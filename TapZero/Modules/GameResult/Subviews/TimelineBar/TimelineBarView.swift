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
                    // Track
                    Capsule()
                        .fill(TapZeroDesign.Hairline.medium)
                        .frame(height: constants.timelineTrackHeight)
                        .frame(maxWidth: .infinity)

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
            Circle()
                .fill(config.isPerfect ? config.scoreColor : TapZeroDesign.Background.primary)
                .frame(
                    width: constants.timelineDotSize,
                    height: constants.timelineDotSize
                )
                .overlay(
                    Circle()
                        .stroke(
                            config.isPerfect
                                ? config.scoreColor
                                : TapZeroDesign.Foreground.primary,
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
                Text(TextKey.GameResult.early)
                    .font(.system(size: 11, weight: .medium))
                    .tracking(0.6)
                    .textCase(.uppercase)
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)

                Spacer()

                Text(config.targetLabel)
                    .font(.system(size: 11, weight: .medium))
                    .tracking(0.6)
                    .textCase(.uppercase)
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)

                Spacer()

                Text(TextKey.GameResult.late)
                    .font(.system(size: 11, weight: .medium))
                    .tracking(0.6)
                    .textCase(.uppercase)
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)
            }
        }
    }
}
