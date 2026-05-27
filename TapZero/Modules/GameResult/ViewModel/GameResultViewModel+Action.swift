//
//  GameResultViewModel+Action.swift
//  TapZero
//

import Foundation

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
    }
}
