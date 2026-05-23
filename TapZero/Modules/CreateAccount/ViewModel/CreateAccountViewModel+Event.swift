//
//  CreateAccountViewModel+Event.swift
//  TapZero
//

// MARK: - Events
extension CreateAccountViewModel {
    enum EventType {
        case pageAppear
        case tappedApple
        case tappedGoogle
        case tappedEmail
        case tappedGuest
        case completedSignIn(provider: String)
        case failedSignIn(provider: String, error: String)
    }

    func sendEvent(type: EventType) {
        switch type {
        case .pageAppear:
            eventManager.ga4.sendEvent(name: "createAccount_viewed", parameters: [:])
        case .tappedApple:
            eventManager.ga4.sendEvent(name: "createAccount_tapped_apple", parameters: [:])
        case .tappedGoogle:
            eventManager.ga4.sendEvent(name: "createAccount_tapped_google", parameters: [:])
        case .tappedEmail:
            eventManager.ga4.sendEvent(name: "createAccount_tapped_email", parameters: [:])
        case .tappedGuest:
            eventManager.ga4.sendEvent(name: "createAccount_tapped_guest", parameters: [:])
        case .completedSignIn(let provider):
            eventManager.ga4.sendEvent(
                name: "createAccount_completed_signIn",
                parameters: ["authProvider": provider]
            )
        case .failedSignIn(let provider, let error):
            eventManager.ga4.sendEvent(
                name: "createAccount_failed_signIn",
                parameters: ["authProvider": provider, "errorMessage": error]
            )
        }
    }
}
