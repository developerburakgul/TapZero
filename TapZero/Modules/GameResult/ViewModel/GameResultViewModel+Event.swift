//
//  GameResultViewModel+Event.swift
//  TapZero
//

// MARK: - Events
extension GameResultViewModel {
    enum EventType {
        case pageAppear
        case closeTapped
        case playAgainTapped
        case shareTapped
    }

    func sendEvent(type: EventType) {
        switch type {
        case .pageAppear:
            eventManager.ga4.sendEvent(name: "game_result_viewed", parameters: [:])
        case .closeTapped:
            eventManager.ga4.sendEvent(name: "game_result_closed", parameters: [:])
        case .playAgainTapped:
            eventManager.ga4.sendEvent(name: "game_result_play_again", parameters: [:])
        case .shareTapped:
            eventManager.ga4.sendEvent(name: "game_result_share_tapped", parameters: [:])
        }
    }
}
