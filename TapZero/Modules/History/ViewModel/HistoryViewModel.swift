//
//  HistoryViewModel.swift
//  TapZero
//

import Combine
import SwiftfulRouting
import SwiftUI

@MainActor
final class HistoryViewModel: ObservableObject {
    // MARK: - Non-Published Properties
    var didAppearOnce: Bool = false
    let router: Router
    let entity: HistoryEntity

    // MARK: - Managers
    @Injected private(set) var eventManager: EventManager

    // MARK: - Published Properties

    // MARK: - Subview Entities

    // MARK: - Init
    init(
        router: Router,
        entity: HistoryEntity
    ) {
        self.router = router
        self.entity = entity
    }
}

// MARK: - Computed Properties
extension HistoryViewModel {
}
