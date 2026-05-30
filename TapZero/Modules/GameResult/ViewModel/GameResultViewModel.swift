//
//  GameResultViewModel.swift
//  TapZero
//

import Combine
import SwiftfulRouting
import SwiftUI

@MainActor
final class GameResultViewModel: ObservableObject {
    // MARK: - Non-Published Properties
    var didAppearOnce: Bool = false
    let router: Router
    let entity: GameResultEntity
    let onPlayAgain: () -> Void
    let onClose: () -> Void

    // MARK: - Managers
    @Injected private(set) var eventManager: EventManager
    @Injected private(set) var userManager: UserManager

    // MARK: - Published Properties

    // MARK: - Init
    init(
        router: Router,
        entity: GameResultEntity,
        onPlayAgain: @escaping () -> Void,
        onClose: @escaping () -> Void
    ) {
        self.router = router
        self.entity = entity
        self.onPlayAgain = onPlayAgain
        self.onClose = onClose
    }
}

// MARK: - Computed Properties
extension GameResultViewModel {
    var score: Int { entity.score }

    var targetTimeFormatted: String {
        String(format: "%.2f", Double(entity.targetSeconds))
    }

    var tappedTimeFormatted: String {
        String(format: "%.2f", entity.tappedSeconds)
    }

    var offLabelText: String {
        if entity.performanceRating == .perfect {
            return String(localized: "gameResult.perfect")
        }
        return String(format: "%.2fs ", entity.delta)
            + String(localized: "gameResult.offSuffix")
    }

    var scoreColor: Color {
        switch entity.performanceRating {
        case .perfect, .good:
            TapZeroDesign.Status.good
        case .mid:
            TapZeroDesign.Status.warn
        case .bad:
            TapZeroDesign.Status.bad
        }
    }

    var offPillBackground: Color {
        switch entity.performanceRating {
        case .perfect, .good:
            TapZeroDesign.Score.goodBackground
        case .mid:
            TapZeroDesign.Score.neutralBackground
        case .bad:
            TapZeroDesign.Score.badBackground
        }
    }

    var userName: String? {
        let name = userManager.currentUser?.displayName ?? ""
        return name.isEmpty ? nil : name
    }

    var profileImageURL: URL? {
        guard let urlString = userManager.currentUser?.profileImageURL else { return nil }
        return URL(string: urlString)
    }

    var timelineUserOffset: CGFloat {
        let maxOff: Double = 1.0
        let pct = min(1.0, entity.delta / maxOff)
        let sign: CGFloat = entity.tappedSeconds > Double(entity.targetSeconds) ? 1 : -1
        return sign * pct * 0.4
    }
}
