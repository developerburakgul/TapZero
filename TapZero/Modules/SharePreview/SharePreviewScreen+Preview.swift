//
//  SharePreviewScreen+Preview.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

// MARK: - Card Only Preview

private let previewAvatarURL = URL(string: "https://avatars.githubusercontent.com/developerburakgul")

private struct CardPreview: View {
    let score: Int
    let target: Int
    let tapped: Double
    let rating: PerformanceRating
    let bgColor: Color

    var body: some View {
        let delta = abs(tapped - Double(target))
        ScoreCardView(
            config: .init(
                score: score,
                scoreColor: scoreColor,
                offLabelText: offLabel,
                offPillBackground: pillBg,
                isPerfect: rating == .perfect,
                targetTimeFormatted: String(format: "%.2f", Double(target)),
                tappedTimeFormatted: String(format: "%.2f", tapped),
                timelineUserOffset: timelineOffset(delta: delta),
                targetSeconds: target,
                cardBackground: bgColor,
                userName: "burak",
                profileImageURL: previewAvatarURL
            ),
            constants: ScoreCardView.Constants()
        )
    }

    private var scoreColor: Color {
        switch rating {
        case .perfect, .good: TapZeroDesign.Status.good
        case .mid: TapZeroDesign.Status.warn
        case .bad: TapZeroDesign.Status.bad
        }
    }

    private var pillBg: Color {
        switch rating {
        case .perfect, .good: TapZeroDesign.Score.goodBackground
        case .mid: TapZeroDesign.Score.neutralBackground
        case .bad: TapZeroDesign.Score.badBackground
        }
    }

    private var offLabel: String {
        if rating == .perfect { return TextKey.localized("gameResult.perfect") }
        let delta = abs(tapped - Double(target))
        return String(format: "%.2fs ", delta) + TextKey.localized("gameResult.offSuffix")
    }

    private func timelineOffset(delta: Double) -> CGFloat {
        let pct = min(1.0, delta / 1.0)
        let sign: CGFloat = tapped > Double(target) ? 1 : -1
        return sign * pct * 0.4
    }
}

// MARK: - Color Grid

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

                        CardPreview(
                            score: score, target: target,
                            tapped: tapped, rating: rating,
                            bgColor: color
                        )
                    }
                }
            }
            .padding(16)
        }
        .background(TapZeroDesign.Background.primary)
    }
}

// MARK: - Full Screen Previews (interactive)

private func screenPreview(
    score: Int, target: Int, tapped: Double,
    rating: PerformanceRating
) -> some View {
    let delta = abs(tapped - Double(target))
    return RouterView(id: "sp-\(score)", addModuleSupport: true) { router in
        SharePreviewBuilder.build(
            router: router,
            entity: SharePreviewEntity(
                score: score, targetSeconds: target,
                tappedSeconds: tapped, delta: delta,
                performanceRating: rating
            )
        )
    }
}

#Preview("Perfect — Screen") {
    screenPreview(score: 1000, target: 10, tapped: 10.00, rating: .perfect)
}

#Preview("Good — Screen") {
    screenPreview(score: 847, target: 5, tapped: 5.08, rating: .good)
}

#Preview("Mid — Screen") {
    screenPreview(score: 640, target: 5, tapped: 4.50, rating: .mid)
}

#Preview("Bad — Screen") {
    screenPreview(score: 320, target: 5, tapped: 6.12, rating: .bad)
}

// MARK: - All Colors × Rating (Light Mode)

#Preview("Perfect × 6 Colors — Light") {
    ColorGridPreview(score: 1000, target: 10, tapped: 10.00, rating: .perfect)
        .environment(\.colorScheme, .light)
}

#Preview("Good × 6 Colors — Light") {
    ColorGridPreview(score: 847, target: 5, tapped: 5.08, rating: .good)
        .environment(\.colorScheme, .light)
}

#Preview("Mid × 6 Colors — Light") {
    ColorGridPreview(score: 640, target: 5, tapped: 4.50, rating: .mid)
        .environment(\.colorScheme, .light)
}

#Preview("Bad × 6 Colors — Light") {
    ColorGridPreview(score: 320, target: 5, tapped: 6.12, rating: .bad)
        .environment(\.colorScheme, .light)
}

// MARK: - All Colors × Rating (Dark Mode)

#Preview("Perfect × 6 Colors — Dark") {
    ColorGridPreview(score: 1000, target: 10, tapped: 10.00, rating: .perfect)
        .environment(\.colorScheme, .dark)
}

#Preview("Good × 6 Colors — Dark") {
    ColorGridPreview(score: 847, target: 5, tapped: 5.08, rating: .good)
        .environment(\.colorScheme, .dark)
}

#Preview("Mid × 6 Colors — Dark") {
    ColorGridPreview(score: 640, target: 5, tapped: 4.50, rating: .mid)
        .environment(\.colorScheme, .dark)
}

#Preview("Bad × 6 Colors — Dark") {
    ColorGridPreview(score: 320, target: 5, tapped: 6.12, rating: .bad)
        .environment(\.colorScheme, .dark)
}
