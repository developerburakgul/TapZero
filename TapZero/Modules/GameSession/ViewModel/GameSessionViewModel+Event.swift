//
//  GameSessionViewModel+Event.swift
//  TapZero
//

// MARK: - Events
extension GameSessionViewModel {
    enum EventType {
        case pageAppear
        case tapped(target: Int, tapped: Double, score: Int)
        case playAgain
        case closed
    }

    func sendEvent(type: EventType) {
        switch type {
        case .pageAppear:
            eventManager.ga4.sendEvent(name: "game_session_viewed", parameters: [:])
        case .tapped(let target, let tapped, let score):
            eventManager.ga4.sendEvent(
                name: "game_tapped",
                parameters: [
                    "target": target,
                    "tapped": tapped,
                    "score": score
                ]
            )
        case .playAgain:
            eventManager.ga4.sendEvent(name: "game_play_again", parameters: [:])
        case .closed:
            eventManager.ga4.sendEvent(name: "game_session_closed", parameters: [:])
        }
    }
}
