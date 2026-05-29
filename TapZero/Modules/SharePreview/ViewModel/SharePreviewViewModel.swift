//
//  SharePreviewViewModel.swift
//  TapZero
//

import Combine
import SwiftfulRouting
import SwiftUI

@MainActor
final class SharePreviewViewModel: ObservableObject {
    // MARK: - Non-Published Properties
    var didAppearOnce: Bool = false
    let router: Router
    let entity: SharePreviewEntity

    // MARK: - Managers
    @Injected private(set) var eventManager: EventManager
    @Injected private(set) var userManager: UserManager

    // MARK: - Published Properties
    @Published var selectedColor: Color = TapZeroDesign.Share.bgDark
    @Published var scoreCard: GameResultScreen.ScoreCardEntity

    // MARK: - Init
    init(router: Router, entity: SharePreviewEntity) {
        self.router = router
        self.entity = entity
        self.scoreCard = .init(
            config: Self.makeScoreCardConfig(
                entity: entity,
                cardBackground: TapZeroDesign.Share.bgDark
            )
        )
    }
}

// MARK: - Private Factory
private extension SharePreviewViewModel {
    static func makeScoreCardConfig(
        entity: SharePreviewEntity,
        cardBackground: Color,
        userName: String? = nil,
        profileImageURL: URL? = nil
    ) -> GameResultScreen.ScoreCardEntity.Config {
        .init(
            score: entity.score,
            scoreColor: scoreColor(for: entity.performanceRating),
            offLabelText: offLabelText(for: entity),
            offPillBackground: offPillBackground(for: entity.performanceRating),
            isPerfect: entity.performanceRating == .perfect,
            targetTimeFormatted: String(format: "%.2f", Double(entity.targetSeconds)),
            tappedTimeFormatted: String(format: "%.2f", entity.tappedSeconds),
            timelineUserOffset: timelineUserOffset(for: entity),
            targetSeconds: entity.targetSeconds,
            cardBackground: cardBackground,
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

    static func offPillBackground(for rating: PerformanceRating) -> Color {
        switch rating {
        case .perfect, .good: TapZeroDesign.Score.goodBackground
        case .mid: TapZeroDesign.Score.neutralBackground
        case .bad: TapZeroDesign.Score.badBackground
        }
    }

    static func offLabelText(for entity: SharePreviewEntity) -> String {
        guard entity.performanceRating != .perfect else {
            return TextKey.localized("gameResult.perfect")
        }
        return String(format: "%.2fs ", entity.delta)
            + TextKey.localized("gameResult.offSuffix")
    }

    static func timelineUserOffset(for entity: SharePreviewEntity) -> CGFloat {
        let pct = min(1.0, entity.delta / 1.0)
        let sign: CGFloat = entity.tappedSeconds > Double(entity.targetSeconds) ? 1 : -1
        return sign * pct * 0.4
    }
}
