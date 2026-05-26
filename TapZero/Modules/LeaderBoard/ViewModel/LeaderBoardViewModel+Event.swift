//
//  LeaderBoardViewModel+Event.swift
//  TapZero
//

// MARK: - Events
extension LeaderBoardViewModel {
    enum EventType {
        case pageAppear
    }

    func sendEvent(type: EventType) {
        switch type {
        case .pageAppear:
            eventManager.ga4.sendEvent(name: "leaderboard_viewed", parameters: [:])
        }
    }
}
