//
//  StoreScreenshotView+Preview.swift
//  TapZero
//

import SwiftUI

// MARK: - Store Share Screen

private struct StoreShareShowcase: View {
    let localeData: StoreLocaleData

    private let constants = ScoreCardView.Constants()

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            cardFan

            Spacer()

            colorPicker
                .padding(.bottom, 20)

            shareButton
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
        }
        .background(TapZeroDesign.Background.primary.ignoresSafeArea())
    }

    // MARK: - Card Fan

    private var cardFan: some View {
        ZStack {
            makeCard(bg: TapZeroDesign.Share.bgOrange, score: 847, target: 5, tapped: 5.08, rating: .good)
                .rotationEffect(.degrees(-24), anchor: .bottom)

            makeCard(bg: TapZeroDesign.Share.bgPurple, score: 912, target: 5, tapped: 5.08, rating: .good)
                .rotationEffect(.degrees(24), anchor: .bottom)

            makeCard(bg: TapZeroDesign.Share.bgGreen, score: 912, target: 5, tapped: 5.08, rating: .good)
                .rotationEffect(.degrees(-12), anchor: .bottom)

            makeCard(bg: TapZeroDesign.Share.bgBlue, score: 612, target: 5, tapped: 5.32, rating: .mid)
                .rotationEffect(.degrees(12), anchor: .bottom)

            makeCard(bg: TapZeroDesign.Share.bgLight, score: 935, target: 5, tapped: 4.93, rating: .good)
                .rotationEffect(.degrees(3), anchor: .bottom)

            makeCard(bg: TapZeroDesign.Share.bgDark, score: 912, target: 5, tapped: 5.08, rating: .good)
        }
        .frame(width: 340)
        .scaleEffect(0.85)
    }

    // MARK: - Color Picker

    private let shareColors: [Color] = [
        TapZeroDesign.Share.bgDark,
        TapZeroDesign.Share.bgLight,
        TapZeroDesign.Share.bgGreen,
        TapZeroDesign.Share.bgBlue,
        TapZeroDesign.Share.bgOrange,
        TapZeroDesign.Share.bgPurple
    ]

    private var colorPicker: some View {
        HStack(spacing: 12) {
            ForEach(Array(shareColors.enumerated()), id: \.offset) { _, color in
                Circle()
                    .fill(color)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Circle().stroke(
                            needsBorder(color)
                                ? TapZeroDesign.Hairline.medium
                                : Color.clear,
                            lineWidth: 1
                        )
                    )
            }
        }
    }

    // MARK: - Share Button

    private var shareButton: some View {
        HStack(spacing: 8) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 16, weight: .semibold))
            Text(TextKey.GameResult.share)
                .font(TapZeroTypography.Label.button)
                .tracking(-0.2)
        }
        .foregroundStyle(TapZeroDesign.Button.primaryForeground)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(TapZeroDesign.Button.primaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Card Builder

    private func makeCard(
        bg: Color,
        score: Int,
        target: Int,
        tapped: Double,
        rating: PerformanceRating
    ) -> some View {
        let delta = abs(tapped - Double(target))
        let pct = min(1.0, delta / 1.0)
        let sign: CGFloat = tapped > Double(target) ? 1 : -1

        return ScoreCardView(
            config: .init(
                score: score,
                scoreColor: scoreColor(rating),
                offLabelText: offLabel(rating, delta: delta),
                offPillBackground: pillBg(rating),
                isPerfect: rating == .perfect,
                targetTimeFormatted: formatTime(Double(target)),
                tappedTimeFormatted: formatTime(tapped),
                timelineUserOffset: sign * pct * 0.4,
                targetSeconds: target,
                cardBackground: bg,
                userName: localeData.userName,
                profileImageURL: nil
            ),
            constants: constants
        )
    }

    // MARK: - Number Formatting

    private var localeNumberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: localeData.localeIdentifier)
        return formatter
    }

    private func formatTime(_ value: Double) -> String {
        localeNumberFormatter.string(from: NSNumber(value: value)) ?? String(format: "%.2f", value)
    }

    // MARK: - Helpers

    private func needsBorder(_ color: Color) -> Bool {
        color == TapZeroDesign.Share.bgLight
            || color == TapZeroDesign.Share.bgDark
    }

    private func scoreColor(_ rating: PerformanceRating) -> Color {
        switch rating {
        case .perfect, .good: TapZeroDesign.Status.good
        case .mid: TapZeroDesign.Status.warn
        case .bad: TapZeroDesign.Status.bad
        }
    }

    private func pillBg(_ rating: PerformanceRating) -> Color {
        switch rating {
        case .perfect, .good: TapZeroDesign.Score.goodBackground
        case .mid: TapZeroDesign.Score.neutralBackground
        case .bad: TapZeroDesign.Score.badBackground
        }
    }

    private func offLabel(_ rating: PerformanceRating, delta: Double) -> String {
        if rating == .perfect { return TextKey.localized("gameResult.perfect") }
        let formatted = formatTime(delta)
        let seconds = TextKey.localized("common.secondsAbbr")
        return formatted + seconds + " " + TextKey.localized("gameResult.offSuffix")
    }
}

// MARK: - Previews (10 Locales)

#Preview("Store Share — EN") {
    StoreLocalePreview(storeLocales[0]) { StoreShareShowcase(localeData: storeLocales[0]) }
}
#Preview("Store Share — TR") {
    StoreLocalePreview(storeLocales[1]) { StoreShareShowcase(localeData: storeLocales[1]) }
}
#Preview("Store Share — AR") {
    StoreLocalePreview(storeLocales[2]) { StoreShareShowcase(localeData: storeLocales[2]) }
}
#Preview("Store Share — DE") {
    StoreLocalePreview(storeLocales[3]) { StoreShareShowcase(localeData: storeLocales[3]) }
}
#Preview("Store Share — ES") {
    StoreLocalePreview(storeLocales[4]) { StoreShareShowcase(localeData: storeLocales[4]) }
}
#Preview("Store Share — FR") {
    StoreLocalePreview(storeLocales[5]) { StoreShareShowcase(localeData: storeLocales[5]) }
}
#Preview("Store Share — IT") {
    StoreLocalePreview(storeLocales[6]) { StoreShareShowcase(localeData: storeLocales[6]) }
}
#Preview("Store Share — JA") {
    StoreLocalePreview(storeLocales[7]) { StoreShareShowcase(localeData: storeLocales[7]) }
}
#Preview("Store Share — KO") {
    StoreLocalePreview(storeLocales[8]) { StoreShareShowcase(localeData: storeLocales[8]) }
}
#Preview("Store Share — PT-BR") {
    StoreLocalePreview(storeLocales[9]) { StoreShareShowcase(localeData: storeLocales[9]) }
}
