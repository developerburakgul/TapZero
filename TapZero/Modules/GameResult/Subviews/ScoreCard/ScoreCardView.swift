//
//  ScoreCardView.swift
//  TapZero
//

import SwiftUI

extension GameResultScreen {
    struct ScoreCardView: View, Equatable {
        let config: ScoreCardEntity.Config
        let constants: Constants

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config
        }

        private var compact: Bool { config.isCompact }

        var body: some View {
            VStack(spacing: 0) {
                brandMark

                heroScore
                    .padding(.top, compact ? 10 : 18)

                offPill
                    .padding(.top, 4)

                timelineSection
                    .padding(.top, compact ? 14 : 22)

                comparisonRow
                    .padding(.top, compact ? 14 : 22)
            }
            .padding(compact ? 16 : 22)
            .padding(.bottom, compact ? 2 : 0)
            .background(config.cardBackground ?? TapZeroDesign.Score.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: compact ? 18 : constants.cardCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: compact ? 18 : constants.cardCornerRadius)
                    .stroke(TapZeroDesign.Hairline.default, lineWidth: 0.5)
            )
            .shadow(
                color: .black.opacity(0.03),
                radius: 1,
                y: 1
            )
            .shadow(
                color: .black.opacity(0.04),
                radius: 10,
                y: 6
            )
        }

        // MARK: - Brand Mark

        private var brandMark: some View {
            HStack(spacing: 7) {
                brandLogo

                Text(TextKey.GameResult.brand)
                    .font(TapZeroTypography.Caption.appName)
                    .tracking(-0.3)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)

                Spacer()

                if let name = config.userName {
                    HStack(spacing: 5) {
                        InitialAvatarView(
                            initial: String(name.prefix(1)).uppercased(),
                            size: 20
                        )

                        Text("@\(name)")
                            .font(.system(size: 12, weight: .semibold))
                            .tracking(-0.2)
                            .foregroundStyle(TapZeroDesign.Foreground.secondary)
                    }
                }
            }
        }

        private var brandLogo: some View {
            ZStack {
                Circle()
                    .stroke(
                        TapZeroDesign.Foreground.primary,
                        lineWidth: 1.2
                    )
                    .frame(
                        width: constants.brandLogoSize,
                        height: constants.brandLogoSize
                    )

                Circle()
                    .fill(TapZeroDesign.Foreground.primary)
                    .frame(
                        width: constants.brandDotSize,
                        height: constants.brandDotSize
                    )
                    .offset(y: -(constants.brandLogoSize / 2) - 1.5)
            }
        }

        // MARK: - Hero Score

        private var heroScore: some View {
            Text(TextKey.number(config.score))
                .font(compact ? TapZeroTypography.Display.scoreCompact : TapZeroTypography.Display.score)
                .tracking(compact ? -4 : constants.heroScoreTracking)
                .monospacedDigit()
                .foregroundStyle(config.scoreColor)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }

        // MARK: - Off Pill

        private var offPill: some View {
            HStack(spacing: 6) {
                Circle()
                    .fill(config.scoreColor)
                    .frame(
                        width: constants.offDotSize,
                        height: constants.offDotSize
                    )

                Text(config.offLabelText)
                    .font(.system(size: 13, weight: .semibold))
                    .tracking(-0.1)
            }
            .foregroundStyle(config.scoreColor)
            .padding(.horizontal, 11)
            .padding(.vertical, 4)
            .background(config.offPillBackground)
            .clipShape(Capsule())
        }

        // MARK: - Timeline

        private var timelineSection: some View {
            let targetLabel = String(
                format: "%@ %.2fs",
                String(localized: "gameResult.target"),
                Double(config.targetSeconds)
            )

            return TimelineBarView(
                config: .init(
                    userOffset: config.timelineUserOffset,
                    scoreColor: config.scoreColor,
                    isPerfect: config.isPerfect,
                    targetLabel: targetLabel
                ),
                constants: constants
            )
        }

        // MARK: - Comparison Row

        private var comparisonRow: some View {
            HStack(spacing: 0) {
                comparisonColumn(
                    label: TextKey.GameResult.target,
                    value: config.targetTimeFormatted,
                    color: TapZeroDesign.Foreground.primary
                )

                Rectangle()
                    .fill(TapZeroDesign.Hairline.default)
                    .frame(width: 1)
                    .padding(.vertical, 4)

                comparisonColumn(
                    label: TextKey.GameResult.you,
                    value: config.tappedTimeFormatted,
                    color: config.scoreColor
                )
            }
            .padding(.top, compact ? 12 : 16)
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(TapZeroDesign.Hairline.default)
                    .frame(height: 0.5)
            }
        }

        private func comparisonColumn(
            label: LocalizedStringKey,
            value: String,
            color: Color
        ) -> some View {
            VStack(spacing: 4) {
                Text(label)
                    .font(TapZeroTypography.Caption.sectionHeader)
                    .tracking(1.2)
                    .textCase(.uppercase)
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)

                HStack(alignment: .firstTextBaseline, spacing: 1) {
                    Text(value)
                        .font(
                            .system(
                                size: compact ? 18 : constants.comparisonFontSize,
                                weight: .semibold
                            )
                        )
                        .tracking(-0.6)
                        .monospacedDigit()
                        .foregroundStyle(color)

                    Text("s")
                        .font(
                            .system(
                                size: constants.comparisonSuffixSize,
                                weight: .regular
                            )
                        )
                        .foregroundStyle(TapZeroDesign.Foreground.tertiary)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
