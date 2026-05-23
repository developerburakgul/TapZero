//
//  TabbarViewModel+Action.swift
//  Created by __Username__ on __Date__
//

import Foundation
import SwiftfulRouting
import SwiftUI

// MARK: - Actions
extension TabbarViewModel {
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
        consumePendingDeepLink()
        startDeepLinkObservation()
    }

    // MARK: - User Actions

    func onTabChanged(_ tab: TabbarTab) {
        userManager.saveLastSelectedTab(tab.rawValue)
    }

    // MARK: - Deep Link

    func consumePendingDeepLink() {
        guard let deepLink = deepLinkManager.consume() else { return }
        handleDeepLink(deepLink)
    }

    func startDeepLinkObservation() {
        Task { [weak self] in
            guard let self else { return }
            for await deepLink in deepLinkManager.deepLinks {
                _ = self.deepLinkManager.consume()
                self.handleDeepLink(deepLink)
            }
        }
    }

    private func handleDeepLink(_ deepLink: DeepLink) {
        switch deepLink {
        case .tab(let tab):
            selectedTab = tab.toTabbarTab
        }
    }

    // MARK: - Tab Builders

    func buildHomeScreen(router: Router) -> some View {
        HomeBuilder.build(router: router)
    }

    func buildFavoritesScreen(router: Router) -> some View {
        FavoritesBuilder.build(router: router)
    }

    func buildSettingsScreen(router: Router) -> some View {
        SettingsBuilder.build(router: router, appRouter: self.router)
    }
}

// MARK: - DeepLink.Tab → TabbarTab Mapping

extension DeepLink.Tab {
    var toTabbarTab: TabbarTab {
        switch self {
        case .home: .home
        case .favorites: .favorites
        case .settings: .settings
        }
    }
}
