//
//  SettingsViewModel+Event.swift
//  TapZero
//

// MARK: - Events
extension SettingsViewModel {
    enum EventType {
        case pageAppear
        case tappedSignIn
        case tappedSignOut
        case completedSignOut
        case tappedDeleteAccount
        case completedDeleteAccount
        case changedLanguage(language: String)
    }

    func sendEvent(type: EventType) {
        switch type {
        case .pageAppear:
            eventManager.ga4.sendEvent(name: "settings_viewed", parameters: [:])
        case .tappedSignIn:
            eventManager.ga4.sendEvent(name: "settings_tapped_signIn", parameters: [:])
        case .tappedSignOut:
            eventManager.ga4.sendEvent(name: "settings_tapped_signOut", parameters: [:])
        case .completedSignOut:
            eventManager.ga4.sendEvent(name: "settings_completed_signOut", parameters: [:])
        case .tappedDeleteAccount:
            eventManager.ga4.sendEvent(name: "settings_tapped_deleteAccount", parameters: [:])
        case .completedDeleteAccount:
            eventManager.ga4.sendEvent(name: "settings_completed_deleteAccount", parameters: [:])
        case .changedLanguage(let language):
            eventManager.ga4.sendEvent(
                name: "settings_changed_language",
                parameters: ["language": language]
            )
        }
    }
}
