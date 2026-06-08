//
//  HistoryViewModel+Action.swift
//  TapZero
//

import Foundation

// MARK: - Actions
extension HistoryViewModel {
    /// Called from .task modifier — first appear only (viewDidLoad)
    func viewDidLoad() async {
        await sendInitialRequests()
    }

    /// Called from .task modifier — every appear (viewWillAppear)
    func viewWillAppear() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchGameHistory() }
            group.addTask { await self.fetchUserStats() }
        }
        configure()
        sendEvent(type: .pageAppear)
    }

    func sendInitialRequests() async {
        isLoading = true
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchGameHistory() }
            group.addTask { await self.fetchUserStats() }
        }
        isLoading = false
        configure()
    }

    // MARK: - Tab

    func onTabChanged(_ tab: HistoryTab) {
        selectedTab = tab
        configure()
        sendEvent(type: .tabSwitched(tab: tab))
    }

    // MARK: - Filter & Sort

    func onFilterTargetChanged(_ target: Int?) {
        filterSortEntity.binding.selectedTarget = target
        configure()
        sendEvent(type: .filterChanged(target: target))
    }

    func onSortOrderChanged(_ order: HistoryScreen.FilterSortEntity.SortOrder) {
        filterSortEntity.binding.sortOrder = order
        configure()
        sendEvent(type: .sortChanged(order: order))
    }

    // MARK: - Play Game

    func onPlayGameTapped() {
        guard let url = URL(string: "tapzero://play") else { return }
        deepLinkManager.handleURL(url)
    }
}
