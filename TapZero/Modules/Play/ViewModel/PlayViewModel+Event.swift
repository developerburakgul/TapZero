//
//  PlayViewModel+Event.swift
//  TapZero
//

// MARK: - Events
extension PlayViewModel {
    enum EventType {
        case pageAppear
    }

    func sendEvent(type: EventType) {
        switch type {
        case .pageAppear:
            eventManager.ga4.sendEvent(name: "play_viewed", parameters: [:])
        }
    }
}
