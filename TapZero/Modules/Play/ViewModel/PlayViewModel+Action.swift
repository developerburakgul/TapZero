//
//  PlayViewModel+Action.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

// MARK: - Actions
extension PlayViewModel {
    /// Called from .task modifier — first appear only (viewDidLoad)
    func viewDidLoad() async {
        await sendInitialRequests()
    }

    /// Called from .task modifier — every appear (viewWillAppear)
    func viewWillAppear() async {
        configure()
        sendEvent(type: .pageAppear)
    }

    func sendInitialRequests() async {
        await withTaskGroup { group in
            group.addTask {
                await self.fetchData()
            }
        }
    }

    // MARK: - User Actions

    func onTargetChanged(_ newTarget: Int) {
        selectedTarget = newTarget
    }

    func onPlayTapped() {
        sendEvent(type: .playTapped(target: selectedTarget))

        let entity = GameSessionEntity(targetSeconds: selectedTarget)
        router.showScreen(.fullScreenCover) { router in
            GameSessionBuilder.build(router: router, entity: entity)
        }
    }
}
