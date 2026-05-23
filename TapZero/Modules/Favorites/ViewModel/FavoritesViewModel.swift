//
//  FavoritesViewModel.swift
//  Created by __Username__ on __Date__
//

import Combine
import SwiftfulRouting
import SwiftUI

@MainActor
final class FavoritesViewModel: ObservableObject {
    // MARK: - Non-Published Properties
    var didAppearOnce: Bool = false
    let router: Router
    let entity: FavoritesEntity

    // MARK: - Managers
    @Injected private(set) var eventManager: EventManager

    // MARK: - Published Properties

    // MARK: - Subview Entities

    // MARK: - Init
    init(
        router: Router,
        entity: FavoritesEntity
    ) {
        self.router = router
        self.entity = entity
    }
}

// MARK: - Computed Properties
extension FavoritesViewModel {
}
