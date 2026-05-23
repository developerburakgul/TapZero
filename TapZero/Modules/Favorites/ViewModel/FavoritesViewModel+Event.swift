//
//  FavoritesViewModel+Event.swift
//  TapZero
//

// MARK: - Events
extension FavoritesViewModel {
    enum EventType {
        case pageAppear
    }

    func sendEvent(type: EventType) {
        switch type {
        case .pageAppear:
            eventManager.ga4.sendEvent(name: "favorites_viewed", parameters: [:])
        }
    }
}
