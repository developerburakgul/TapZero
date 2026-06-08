//
//  ScoreCardConstants.swift
//  TapZero
//

import SwiftUI

extension ScoreCardView {
    @MainActor
    struct Constants {
        // Brand
        let brandLogoSize: CGFloat = 16
        let brandDotSize: CGFloat = 3
        let offDotSize: CGFloat = 5

        // Timeline
        let timelineTrackHeight: CGFloat = 2
        let timelineDotSize: CGFloat = 14
        let timelineDotBorderWidth: CGFloat = 2

        // MARK: - Share Card Themes

        func shareCardTheme(for color: Color?) -> ScoreCardEntity.ShareCardTheme? {
            guard let color else { return nil }
            if color == TapZeroDesign.Share.bgDark { return shareThemeDark }
            if color == TapZeroDesign.Share.bgLight { return shareThemeLight }
            if color == TapZeroDesign.Share.bgGreen { return shareThemeGreen }
            if color == TapZeroDesign.Share.bgBlue { return shareThemeBlue }
            if color == TapZeroDesign.Share.bgOrange { return shareThemeOrange }
            if color == TapZeroDesign.Share.bgPurple { return shareThemePurple }
            return nil
        }

        private func gradient(_ start: Color, _ end: Color) -> AnyShapeStyle {
            AnyShapeStyle(LinearGradient(
                colors: [start, end],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.3, y: 1)
            ))
        }

        private func darkTheme(cardBackground: AnyShapeStyle) -> ScoreCardEntity.ShareCardTheme {
            let base = Color(hex: "#FAF9F6")
            return .init(
                cardBackground: cardBackground,
                foreground: base,
                secondaryForeground: base.opacity(0.6),
                tertiaryForeground: base.opacity(0.35),
                hairline: base.opacity(0.10),
                trackBackground: base.opacity(0.12),
                targetDotFill: base.opacity(0.06),
                badgePillOpacity: 0.15,
                avatarBackground: base.opacity(0.12)
            )
        }

        private var shareThemeDark: ScoreCardEntity.ShareCardTheme {
            darkTheme(cardBackground: gradient(Color(hex: "#2A2A2E"), Color(hex: "#141416")))
        }

        private var shareThemeLight: ScoreCardEntity.ShareCardTheme {
            .init(
                cardBackground: gradient(Color(hex: "#FFFFFF"), Color(hex: "#F0EDE6")),
                foreground: Color(hex: "#0B0B0C"),
                secondaryForeground: Color(hex: "#6B6B70"),
                tertiaryForeground: Color(hex: "#A8A8AD"),
                hairline: Color(hex: "#0B0B0C").opacity(0.08),
                trackBackground: Color(hex: "#0B0B0C").opacity(0.08),
                targetDotFill: Color(hex: "#FFFFFF"),
                badgePillOpacity: nil,
                avatarBackground: Color(hex: "#EFEEE8"),
                isDarkBackground: false
            )
        }

        private var shareThemeGreen: ScoreCardEntity.ShareCardTheme {
            darkTheme(cardBackground: gradient(Color(hex: "#1E3D2A"), Color(hex: "#0F1E15")))
        }

        private var shareThemeBlue: ScoreCardEntity.ShareCardTheme {
            darkTheme(cardBackground: gradient(Color(hex: "#1E2F50"), Color(hex: "#0F1724")))
        }

        private var shareThemeOrange: ScoreCardEntity.ShareCardTheme {
            darkTheme(cardBackground: gradient(Color(hex: "#7A3018"), Color(hex: "#3A1208")))
        }

        private var shareThemePurple: ScoreCardEntity.ShareCardTheme {
            darkTheme(cardBackground: gradient(Color(hex: "#3E2870"), Color(hex: "#1E1038")))
        }
    }
}
