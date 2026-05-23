//
//  SplashViewModel+Event.swift
//  TapZero
//

// MARK: - Events
extension SplashViewModel {
    enum EventType {
        case pageAppear
        case completedRouting
    }

    func sendEvent(type: EventType) {
        switch type {
        case .pageAppear:
            eventManager.ga4.sendEvent(name: "splash_viewed", parameters: [:])
        case .completedRouting:
            eventManager.ga4.sendEvent(name: "splash_completed_routing", parameters: [:])
        }
    }
}
