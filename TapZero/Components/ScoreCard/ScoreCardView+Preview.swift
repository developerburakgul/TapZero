//
//  ScoreCardView+Preview.swift
//  TapZero
//

import SwiftUI

// MARK: - Preview Helpers

@MainActor
private struct ScoreCardPreview {
    static let avatarURL = URL(string: "https://avatars.githubusercontent.com/developerburakgul")

    static func config(
        score: Int,
        target: Int,
        tapped: Double,
        rating: PerformanceRating,
        bgColor: Color? = nil,
        userName: String? = "burak",
        profileImageURL: URL? = avatarURL
    ) -> ScoreCardEntity.Config {
        let delta = abs(tapped - Double(target))
        return .init(
            score: score,
            scoreColor: scoreColor(for: rating),
            offLabelText: offLabel(rating: rating, delta: delta),
            offPillBackground: pillBackground(for: rating),
            isPerfect: rating == .perfect,
            targetTimeFormatted: String(format: "%.2f", Double(target)),
            tappedTimeFormatted: String(format: "%.2f", tapped),
            timelineUserOffset: timelineOffset(delta: delta, tapped: tapped, target: target),
            targetSeconds: target,
            cardBackground: bgColor,
            userName: userName,
            profileImageURL: profileImageURL
        )
    }

    static func scoreColor(for rating: PerformanceRating) -> Color {
        switch rating {
        case .perfect, .good: TapZeroDesign.Status.good
        case .mid: TapZeroDesign.Status.warn
        case .bad: TapZeroDesign.Status.bad
        }
    }

    static func pillBackground(for rating: PerformanceRating) -> Color {
        switch rating {
        case .perfect, .good: TapZeroDesign.Score.goodBackground
        case .mid: TapZeroDesign.Score.neutralBackground
        case .bad: TapZeroDesign.Score.badBackground
        }
    }

    static func offLabel(rating: PerformanceRating, delta: Double) -> String {
        if rating == .perfect { return TextKey.localized("gameResult.perfect") }
        return String(format: "%.2fs ", delta) + TextKey.localized("gameResult.offSuffix")
    }

    static func timelineOffset(delta: Double, tapped: Double, target: Int) -> CGFloat {
        let pct = min(1.0, delta / 1.0)
        let sign: CGFloat = tapped > Double(target) ? 1 : -1
        return sign * pct * 0.4
    }
}

// MARK: - Single Card Previews

#Preview("Good — Default") {
    ScoreCardView(
        config: ScoreCardPreview.config(score: 847, target: 5, tapped: 5.08, rating: .good),
        constants: ScoreCardView.Constants()
    )
    .padding(20)
    .background(TapZeroDesign.Background.primary)
}

#Preview("Perfect — Default") {
    ScoreCardView(
        config: ScoreCardPreview.config(score: 1000, target: 10, tapped: 10.00, rating: .perfect),
        constants: ScoreCardView.Constants()
    )
    .padding(20)
    .background(TapZeroDesign.Background.primary)
}

#Preview("Mid — Default") {
    ScoreCardView(
        config: ScoreCardPreview.config(score: 640, target: 5, tapped: 4.50, rating: .mid),
        constants: ScoreCardView.Constants()
    )
    .padding(20)
    .background(TapZeroDesign.Background.primary)
}

#Preview("Bad — Default") {
    ScoreCardView(
        config: ScoreCardPreview.config(score: 320, target: 5, tapped: 6.12, rating: .bad),
        constants: ScoreCardView.Constants()
    )
    .padding(20)
    .background(TapZeroDesign.Background.primary)
}

// MARK: - All Colors Grid

private struct ColorGridPreview: View {
    let score: Int
    let target: Int
    let tapped: Double
    let rating: PerformanceRating

    private var colors: [(String, Color)] {
        [
            ("Dark", TapZeroDesign.Share.bgDark),
            ("Light", TapZeroDesign.Share.bgLight),
            ("Green", TapZeroDesign.Share.bgGreen),
            ("Blue", TapZeroDesign.Share.bgBlue),
            ("Orange", TapZeroDesign.Share.bgOrange),
            ("Purple", TapZeroDesign.Share.bgPurple)
        ]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(colors, id: \.0) { name, color in
                    VStack(spacing: 6) {
                        Text(name)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.secondary)

                        ScoreCardView(
                            config: ScoreCardPreview.config(
                                score: score,
                                target: target,
                                tapped: tapped,
                                rating: rating,
                                bgColor: color
                            ),
                            constants: ScoreCardView.Constants()
                        )
                    }
                }
            }
            .padding(16)
        }
        .background(TapZeroDesign.Background.primary)
    }
}

#Preview("Good × 6 Colors — Light") {
    ColorGridPreview(score: 847, target: 5, tapped: 5.08, rating: .good)
        .environment(\.colorScheme, .light)
}

#Preview("Good × 6 Colors — Dark") {
    ColorGridPreview(score: 847, target: 5, tapped: 5.08, rating: .good)
        .environment(\.colorScheme, .dark)
}

#Preview("Perfect × 6 Colors — Light") {
    ColorGridPreview(score: 1000, target: 10, tapped: 10.00, rating: .perfect)
        .environment(\.colorScheme, .light)
}

#Preview("Bad × 6 Colors — Light") {
    ColorGridPreview(score: 320, target: 5, tapped: 6.12, rating: .bad)
        .environment(\.colorScheme, .light)
}
