//
//  WelcomeViewModel+Event.swift
//  TapZero
//

// MARK: - Events
extension WelcomeViewModel {
    enum EventType {
        case pageAppear
        case tappedSignIn
        case tappedStartFresh
    }

    func sendEvent(type: EventType) {
        switch type {
        case .pageAppear:
            eventManager.ga4.sendEvent(name: "welcome_viewed", parameters: [:])
        case .tappedSignIn:
            eventManager.ga4.sendEvent(name: "welcome_tapped_signIn", parameters: [:])
        case .tappedStartFresh:
            eventManager.ga4.sendEvent(name: "welcome_tapped_startFresh", parameters: [:])
        }
    }
}
