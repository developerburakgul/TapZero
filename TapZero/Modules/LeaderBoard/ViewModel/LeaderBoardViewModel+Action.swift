//
//  LeaderBoardViewModel+Action.swift
//  TapZero
//

import Foundation

// MARK: - Actions
extension LeaderBoardViewModel {
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
        isLoading = true
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchGlobalLeaderboard() }
            group.addTask { await self.fetchDailyLeaderboard() }
            group.addTask { await self.fetchUserStats() }
        }
        isLoading = false
    }

    // MARK: - User Interactions

    func onTabChanged(_ tab: LeaderBoardTab) {
        selectedTab = tab
        sendEvent(type: .tabSwitched(tab: tab))
    }

    func onPlayGameTapped() {
        guard let url = URL(string: "tapzero://play") else { return }
        deepLinkManager.handleURL(url)
    }
}
