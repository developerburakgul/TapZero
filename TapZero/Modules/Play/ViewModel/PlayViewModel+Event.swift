//
//  PlayViewModel+Event.swift
//  TapZero
//

// MARK: - Events
extension PlayViewModel {
    enum EventType {
        case pageAppear
        case playTapped(target: Int)
        case targetChanged(target: Int)
    }

    func sendEvent(type: EventType) {
        switch type {
        case .pageAppear:
            eventManager.ga4.sendEvent(name: "play_viewed", parameters: [:])
        case .playTapped(let target):
            eventManager.ga4.sendEvent(name: "play_tapped", parameters: ["target": target])
        case .targetChanged(let target):
            eventManager.ga4.sendEvent(name: "target_changed", parameters: ["target": target])
        }
    }
}
