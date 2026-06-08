//
//  ScoreCardView.swift
//  TapZero
//

import DynamicColor
import SwiftUI

struct ScoreCardView: View, Equatable {
    let config: ScoreCardEntity.Config
    let constants: Constants
    @ObservedObject private var themeStore = ThemeStore.shared

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.config == rhs.config
    }

    private var shareTheme: ScoreCardEntity.ShareCardTheme? {
        constants.shareCardTheme(for: config.cardBackground)
    }

    var body: some View {
        VStack(spacing: 0) {
            brandMark

            heroScore
                .padding(.top, 18)

            offPill
                .padding(.top, 4)

            timelineSection
                .padding(.top, 22)

            comparisonRow
                .padding(.top, 22)
        }
        .padding(.horizontal, 22)
        .padding(.top, 22)
        .padding(.bottom, 26)
        .background(shareTheme?.cardBackground ?? AnyShapeStyle(TapZeroDesign.Score.cardBackground))
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(shareTheme?.hairline ?? TapZeroDesign.Hairline.default, lineWidth: 0.5)
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
        .fixedSize(horizontal: false, vertical: true)
    }

    // MARK: - Brand Mark

    private var brandMark: some View {
        HStack(spacing: 7) {
            brandLogo

            Text(TextKey.GameResult.brand)
                .font(TapZeroTypography.Caption.appName)
                .tracking(-0.3)
                .foregroundStyle(shareTheme?.foreground ?? TapZeroDesign.Foreground.primary)

            Spacer()

            if let name = config.userName {
                HStack(spacing: 5) {
                    avatarView(name: name)

                    Text(name)
                        .font(.system(size: 12, weight: .semibold))
                        .tracking(-0.2)
                        .foregroundStyle(shareTheme?.secondaryForeground ?? TapZeroDesign.Foreground.secondary)
                }
            }
        }
    }

    @ViewBuilder
    private func avatarView(name: String) -> some View {
        let initial = String(name.prefix(1)).uppercased()
        if let url = config.profileImageURL {
            CachedAsyncImage(url: url) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                InitialAvatarView(
                    initial: initial,
                    size: 20,
                    foregroundColor: shareTheme?.foreground,
                    backgroundColor: shareTheme?.avatarBackground
                )
            }
            .frame(width: 20, height: 20)
            .clipShape(Circle())
        } else {
            InitialAvatarView(
                initial: initial,
                size: 20,
                foregroundColor: shareTheme?.foreground,
                backgroundColor: shareTheme?.avatarBackground
            )
        }
    }

    private var brandLogo: some View {
        let isDark: Bool = if let shareTheme {
            shareTheme.isDarkBackground
        } else {
            themeStore.theme == .dark
                || (themeStore.theme == .system
                    && UITraitCollection.current.userInterfaceStyle == .dark)
        }
        return Image(isDark ? "AppIcon-Dark" : "AppIcon-Light")
            .resizable()
            .scaledToFit()
            .frame(width: constants.brandLogoSize, height: constants.brandLogoSize)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    // MARK: - Hero Score

    private var heroScore: some View {
        Text(TextKey.number(config.score))
            .font(TapZeroTypography.Display.score)
            .tracking(-7)
            .monospacedDigit()
            .foregroundStyle(config.scoreColor)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .padding(.horizontal, 8)
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
        .background(
            shareTheme.flatMap { theme in
                theme.badgePillOpacity.map { config.scoreColor.opacity($0) }
            } ?? config.offPillBackground
        )
        .clipShape(Capsule())
    }

    // MARK: - Timeline

    private var timelineSection: some View {
        GameResultScreen.TimelineBarView(
            config: .init(
                userOffset: config.timelineUserOffset,
                scoreColor: config.scoreColor,
                isPerfect: config.isPerfect,
                foregroundOverride: shareTheme?.foreground,
                hairlineOverride: shareTheme?.trackBackground,
                targetDotFillOverride: shareTheme?.targetDotFill
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
                color: shareTheme?.foreground ?? TapZeroDesign.Foreground.primary
            )

            Rectangle()
                .fill(shareTheme?.hairline ?? TapZeroDesign.Hairline.default)
                .frame(width: 1, height: 36)

            comparisonColumn(
                label: TextKey.GameResult.you,
                value: config.tappedTimeFormatted,
                color: config.scoreColor
            )
        }
        .padding(.top, 16)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(shareTheme?.hairline ?? TapZeroDesign.Hairline.default)
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
                .foregroundStyle(shareTheme?.tertiaryForeground ?? TapZeroDesign.Foreground.tertiary)

            HStack(alignment: .firstTextBaseline, spacing: 1) {
                Text(value)
                    .font(.system(size: 22, weight: .semibold))
                    .tracking(-0.6)
                    .monospacedDigit()
                    .foregroundStyle(color)

                Text(TextKey.Common.secondsAbbr)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(shareTheme?.tertiaryForeground ?? TapZeroDesign.Foreground.tertiary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
