//
//  PlayViewModel.swift
//  TapZero
//

import Combine
import SwiftfulRouting
import SwiftUI

@MainActor
final class PlayViewModel: ObservableObject {
    // MARK: - Non-Published Properties
    var didAppearOnce: Bool = false
    let router: Router
    let entity: PlayEntity

    // MARK: - Managers
    @Injected private(set) var eventManager: EventManager
    @Injected private(set) var userManager: UserManager
    @Injected private(set) var gameManager: GameManager

    // MARK: - Published Properties
    @Published var selectedTarget: Int = 10

    // MARK: - Subview Entities

    // MARK: - Init
    init(
        router: Router,
        entity: PlayEntity
    ) {
        self.router = router
        self.entity = entity
    }
}

// MARK: - Computed Properties
extension PlayViewModel {
    var userName: String {
        userManager.currentUser?.displayName ?? ""
    }

    var userInitial: String {
        String(userName.prefix(1)).uppercased()
    }

    var avatarColor: Color {
        userManager.currentUser?.profileColorCalculated ?? TapZeroDesign.Accent.primary
    }

    var bestScore: Int? {
        gameManager.userStats?.bestScore
    }
}
