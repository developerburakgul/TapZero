//
//  OnboardingViewModel+Event.swift
//  TapZero
//

// MARK: - Events
extension OnboardingViewModel {
    enum EventType {
        case pageAppear
        case completedStep(step: Int)
        case completedAll
        case tappedSkipPhoto
        case selectedPhoto
        case tappedEnableNotification
        case tappedSkipNotification
        case completedNotificationPermission(granted: Bool)
        case tappedGetStarted
    }

    func sendEvent(type: EventType) {
        switch type {
        case .pageAppear:
            eventManager.ga4.sendEvent(name: "onboarding_viewed", parameters: [:])
        case .completedStep(let step):
            eventManager.ga4.sendEvent(
                name: "onboarding_completed_step",
                parameters: ["stepNumber": step]
            )
        case .completedAll:
            eventManager.ga4.sendEvent(name: "onboarding_completed_all", parameters: [:])
        case .tappedSkipPhoto:
            eventManager.ga4.sendEvent(name: "onboarding_tapped_skipPhoto", parameters: [:])
        case .selectedPhoto:
            eventManager.ga4.sendEvent(name: "onboarding_selected_photo", parameters: [:])
        case .tappedEnableNotification:
            eventManager.ga4.sendEvent(name: "onboarding_tapped_enableNotification", parameters: [:])
        case .tappedSkipNotification:
            eventManager.ga4.sendEvent(name: "onboarding_tapped_skipNotification", parameters: [:])
        case .completedNotificationPermission(let granted):
            eventManager.ga4.sendEvent(
                name: "onboarding_completed_notificationPermission",
                parameters: ["granted": granted]
            )
        case .tappedGetStarted:
            eventManager.ga4.sendEvent(name: "onboarding_tapped_getStarted", parameters: [:])
        }
    }
}
