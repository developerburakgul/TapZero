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

    // MARK: - Init
    init(router: Router, entity: SharePreviewEntity) {
        self.router = router
        self.entity = entity
    }
}

// MARK: - Computed Properties
extension SharePreviewViewModel {
    var score: Int { entity.score }

    var userName: String? {
        let name = userManager.currentUser?.displayName ?? ""
        return name.isEmpty ? nil : name
    }

    var targetTimeFormatted: String {
        String(format: "%.2f", Double(entity.targetSeconds))
    }

    var tappedTimeFormatted: String {
        String(format: "%.2f", entity.tappedSeconds)
    }

    var offLabelText: String {
        if entity.performanceRating == .perfect {
            return TextKey.localized("gameResult.perfect")
        }
        return String(format: "%.2fs ", entity.delta)
            + TextKey.localized("gameResult.offSuffix")
    }

    var scoreColor: Color {
        switch entity.performanceRating {
        case .perfect, .good: TapZeroDesign.Status.good
        case .mid: TapZeroDesign.Status.warn
        case .bad: TapZeroDesign.Status.bad
        }
    }

    var offPillBackground: Color {
        switch entity.performanceRating {
        case .perfect, .good: TapZeroDesign.Score.goodBackground
        case .mid: TapZeroDesign.Score.neutralBackground
        case .bad: TapZeroDesign.Score.badBackground
        }
    }

    var timelineUserOffset: CGFloat {
        let maxOff: Double = 1.0
        let pct = min(1.0, entity.delta / maxOff)
        let sign: CGFloat = entity.tappedSeconds > Double(entity.targetSeconds) ? 1 : -1
        return sign * pct * 0.4
    }
}
