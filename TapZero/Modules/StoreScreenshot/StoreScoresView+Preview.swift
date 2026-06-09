//
//  StoreScoresView+Preview.swift
//  TapZero
//

import SwiftUI

// MARK: - Score Card Step

private struct ScoreStep {
    let score: Int
    let target: Int
    let tapped: Double
    let rating: PerformanceRating
    let rotation: Double
    let scale: CGFloat
}

private let scoreSteps: [ScoreStep] = [
    .init(score: 640, target: 5, tapped: 4.50, rating: .mid, rotation: -8, scale: 0.88),
    .init(score: 847, target: 5, tapped: 5.08, rating: .good, rotation: 5, scale: 0.94),
    .init(score: 1000, target: 10, tapped: 10.00, rating: .perfect, rotation: 0, scale: 1.0)
]

// MARK: - Scores Fan Showcase

private struct StoreScoresShowcase: View {
    let localeData: StoreLocaleData

    private let cardConstants = ScoreCardView.Constants()
    private let formatter: StoreNumberFormatter

    init(localeData: StoreLocaleData) {
        self.localeData = localeData
        self.formatter = StoreNumberFormatter(localeIdentifier: localeData.localeIdentifier)
    }

    var body: some View {
        ZStack {
            TapZeroDesign.Background.primary.ignoresSafeArea()

            cardFan
        }
    }

    // MARK: - Card Fan

    private var cardFan: some View {
        ZStack {
            ForEach(Array(scoreSteps.enumerated()), id: \.offset) { _, step in
                makeCard(step)
                    .rotationEffect(.degrees(step.rotation), anchor: .bottom)
                    .scaleEffect(step.scale)
            }
        }
        .frame(width: 340)
        .scaleEffect(0.92)
    }

    // MARK: - Card Builder

    private func makeCard(_ step: ScoreStep) -> some View {
        let delta = abs(step.tapped - Double(step.target))
        let pct = min(1.0, delta / 1.0)
        let sign: CGFloat = step.tapped > Double(step.target) ? 1 : -1

        return ScoreCardView(
            config: .init(
                score: step.score,
                scoreColor: scoreColor(step.rating),
                offLabelText: offLabel(step.rating, delta: delta),
                offPillBackground: pillBg(step.rating),
                isPerfect: step.rating == .perfect,
                targetTimeFormatted: formatter.formatTime(Double(step.target)),
                tappedTimeFormatted: formatter.formatTime(step.tapped),
                timelineUserOffset: sign * pct * 0.4,
                targetSeconds: step.target,
                cardBackground: nil,
                userName: localeData.userName,
                profileImageURL: nil
            ),
            constants: cardConstants
        )
    }

    // MARK: - Helpers

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
        let formatted = formatter.formatTime(delta)
        let seconds = TextKey.localized("common.secondsAbbr")
        return formatted + seconds + " " + TextKey.localized("gameResult.offSuffix")
    }
}

// MARK: - Previews (10 Locales)

#Preview("Store Scores — EN") {
    StoreLocalePreview(storeLocales[0]) { StoreScoresShowcase(localeData: storeLocales[0]) }
}
#Preview("Store Scores — TR") {
    StoreLocalePreview(storeLocales[1]) { StoreScoresShowcase(localeData: storeLocales[1]) }
}
#Preview("Store Scores — AR") {
    StoreLocalePreview(storeLocales[2]) { StoreScoresShowcase(localeData: storeLocales[2]) }
}
#Preview("Store Scores — DE") {
    StoreLocalePreview(storeLocales[3]) { StoreScoresShowcase(localeData: storeLocales[3]) }
}
#Preview("Store Scores — ES") {
    StoreLocalePreview(storeLocales[4]) { StoreScoresShowcase(localeData: storeLocales[4]) }
}
#Preview("Store Scores — FR") {
    StoreLocalePreview(storeLocales[5]) { StoreScoresShowcase(localeData: storeLocales[5]) }
}
#Preview("Store Scores — IT") {
    StoreLocalePreview(storeLocales[6]) { StoreScoresShowcase(localeData: storeLocales[6]) }
}
#Preview("Store Scores — JA") {
    StoreLocalePreview(storeLocales[7]) { StoreScoresShowcase(localeData: storeLocales[7]) }
}
#Preview("Store Scores — KO") {
    StoreLocalePreview(storeLocales[8]) { StoreScoresShowcase(localeData: storeLocales[8]) }
}
#Preview("Store Scores — PT-BR") {
    StoreLocalePreview(storeLocales[9]) { StoreScoresShowcase(localeData: storeLocales[9]) }
}
