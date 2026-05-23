//
//  HomeViewModel+Event.swift
//  TapZero
//

// MARK: - Events
extension HomeViewModel {
    enum EventType {
        case pageAppear
    }

    func sendEvent(type: EventType) {
        switch type {
        case .pageAppear:
            eventManager.ga4.sendEvent(name: "home_viewed", parameters: [:])
        }
    }
}
