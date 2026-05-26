//
//  HistoryViewModel+Event.swift
//  TapZero
//

// MARK: - Events
extension HistoryViewModel {
    enum EventType {
        case pageAppear
    }

    func sendEvent(type: EventType) {
        switch type {
        case .pageAppear:
            eventManager.ga4.sendEvent(name: "history_viewed", parameters: [:])
        }
    }
}
