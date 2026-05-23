//
//  ForceUpdateViewModel+Event.swift
//  TapZero
//

// MARK: - Events
extension ForceUpdateViewModel {
    enum EventType {
        case pageAppear
        case tappedUpdate
    }

    func sendEvent(type: EventType) {
        switch type {
        case .pageAppear:
            eventManager.ga4.sendEvent(name: "forceUpdate_viewed", parameters: [:])
        case .tappedUpdate:
            eventManager.ga4.sendEvent(name: "forceUpdate_tapped_update", parameters: [:])
        }
    }
}
