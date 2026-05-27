//
//  LeaderBoardViewModel+Event.swift
//  TapZero
//

// MARK: - Events
extension LeaderBoardViewModel {
    enum EventType {
        case pageAppear
        case tabSwitched(tab: LeaderBoardTab)
    }

    func sendEvent(type: EventType) {
        switch type {
        case .pageAppear:
            eventManager.ga4.sendEvent(name: "leaderboard_viewed", parameters: [:])
        case .tabSwitched(let tab):
            eventManager.ga4.sendEvent(
                name: "leaderboard_switched_tab",
                parameters: ["tab": tab == .global ? "global" : "daily"]
            )
        }
    }
}
