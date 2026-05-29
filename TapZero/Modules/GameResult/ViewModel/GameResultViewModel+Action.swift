//
//  GameResultViewModel+Action.swift
//  TapZero
//

import Foundation
import SwiftfulRouting

// MARK: - Actions
extension GameResultViewModel {
    func viewDidLoad() async {
    }

    func viewWillAppear() async {
        configure()
        sendEvent(type: .pageAppear)
    }

    // MARK: - User Actions

    func onCloseTapped() {
        sendEvent(type: .closeTapped)
        router.dismissScreen()
        onClose()
    }

    func onPlayAgainTapped() {
        sendEvent(type: .playAgainTapped)
        router.dismissScreen()
        onPlayAgain()
    }

    func onShareTapped() {
        sendEvent(type: .shareTapped)
        let shareEntity = SharePreviewEntity(
            score: entity.score,
            targetSeconds: entity.targetSeconds,
            tappedSeconds: entity.tappedSeconds,
            delta: entity.delta,
            performanceRating: entity.performanceRating
        )
        router.showScreen(.sheet) { router in
            SharePreviewBuilder.build(router: router, entity: shareEntity)
        }
    }
}
