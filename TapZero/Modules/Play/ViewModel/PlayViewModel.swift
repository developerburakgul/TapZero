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

    // MARK: - Published Properties

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
}
