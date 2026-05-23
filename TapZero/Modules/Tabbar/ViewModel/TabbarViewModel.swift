//
//  TabbarViewModel.swift
//  Created by __Username__ on __Date__
//

import SwiftfulRouting
import SwiftUI

enum TabbarTab: Int, CaseIterable {
    case home, favorites, settings
}

@MainActor
final class TabbarViewModel: ObservableObject {
    // MARK: - Non-Published Properties
    var didAppearOnce: Bool = false
    let router: Router
    let entity: TabbarEntity

    // MARK: - Managers
    @Injected private(set) var userManager: UserManager
    @Injected private(set) var deepLinkManager: DeepLinkManager
    @Injected private(set) var eventManager: EventManager

    // MARK: - Published Properties
    @Published var selectedTab: TabbarTab = .home

    // MARK: - Subview Entities

    // MARK: - Init
    init(
        router: Router,
        entity: TabbarEntity
    ) {
        self.router = router
        self.entity = entity

        // Entity'den gelen başlangıç tab'ını yükle
        if let tabIndex = entity.initialTab,
           let tab = TabbarTab(rawValue: tabIndex) {
            self.selectedTab = tab
        }
    }
}

// MARK: - Computed Properties
extension TabbarViewModel {
}
