//
//  EmailAuthViewModel+Event.swift
//  TapZero
//

// MARK: - Events
extension EmailAuthViewModel {
    enum EventType {
        case pageAppear
        case submittedSignIn
        case submittedCreateAccount
        case failedValidation(error: String)
    }

    func sendEvent(type: EventType) {
        switch type {
        case .pageAppear:
            eventManager.ga4.sendEvent(name: "emailAuth_viewed", parameters: [:])
        case .submittedSignIn:
            eventManager.ga4.sendEvent(name: "emailAuth_submitted_signIn", parameters: [:])
        case .submittedCreateAccount:
            eventManager.ga4.sendEvent(name: "emailAuth_submitted_createAccount", parameters: [:])
        case .failedValidation(let error):
            eventManager.ga4.sendEvent(
                name: "emailAuth_failed_validation",
                parameters: ["errorMessage": error]
            )
        }
    }
}
