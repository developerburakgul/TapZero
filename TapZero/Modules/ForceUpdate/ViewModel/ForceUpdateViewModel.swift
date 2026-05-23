//
//  ForceUpdateViewModel.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

@MainActor
final class ForceUpdateViewModel: ObservableObject {
    // MARK: - Non-Published Properties
    var didAppearOnce: Bool = false
    let router: Router
    let entity: ForceUpdateEntity

    // MARK: - Managers
    @Injected private(set) var eventManager: EventManager

    // MARK: - Published Properties

    // MARK: - Init
    init(
        router: Router,
        entity: ForceUpdateEntity
    ) {
        self.router = router
        self.entity = entity
    }
}

// MARK: - Computed Properties
extension ForceUpdateViewModel {
}
