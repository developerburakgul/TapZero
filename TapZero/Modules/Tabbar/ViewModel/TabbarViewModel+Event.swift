//
//  TabbarViewModel+Event.swift
//  TapZero
//

// MARK: - Events
extension TabbarViewModel {
    enum EventType {
        case pageAppear
    }

    func sendEvent(type: EventType) {
        switch type {
        case .pageAppear:
            eventManager.ga4.sendEvent(name: "tabbar_viewed", parameters: [:])
        }
    }
}
