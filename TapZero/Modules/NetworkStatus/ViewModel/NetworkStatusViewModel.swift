//
//  NetworkStatusViewModel.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

@MainActor
final class NetworkStatusViewModel: ObservableObject {
    // MARK: - Non-Published Properties
    var didAppearOnce: Bool = false
    let router: Router
    let entity: NetworkStatusEntity

    // MARK: - Managers
    @Injected private(set) var eventManager: EventManager

    // MARK: - Published Properties

    // MARK: - Init
    init(
        router: Router,
        entity: NetworkStatusEntity
    ) {
        self.router = router
        self.entity = entity
    }
}

// MARK: - Computed Properties
extension NetworkStatusViewModel {
}
