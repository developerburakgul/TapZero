//
//  NetworkStatusViewModel+Event.swift
//  TapZero
//

// MARK: - Events
extension NetworkStatusViewModel {
    enum EventType {
        case pageAppear
    }

    func sendEvent(type: EventType) {
        switch type {
        case .pageAppear:
            eventManager.ga4.sendEvent(name: "networkStatus_viewed", parameters: [:])
        }
    }
}
