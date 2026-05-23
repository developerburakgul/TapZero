//
//  TextKey+Onboarding.swift
//  TapZero
//

import SwiftUI

extension TextKey {
    enum Onboarding {
        static let continueButton: LocalizedStringKey = "onboarding.continue"
        static let skip: LocalizedStringKey = "onboarding.skip"

        // Intro 1
        static let intro1Title: LocalizedStringKey = "onboarding.intro1.title"
        static let intro1Subtitle: LocalizedStringKey = "onboarding.intro1.subtitle"

        // Intro 2
        static let intro2Title: LocalizedStringKey = "onboarding.intro2.title"
        static let intro2Subtitle: LocalizedStringKey = "onboarding.intro2.subtitle"

        // Step 1: Name
        static let nameTitle: LocalizedStringKey = "onboarding.name.title"
        static let nameSubtitle: LocalizedStringKey = "onboarding.name.subtitle"

        // Step 2: Photo
        static let photoTitle: LocalizedStringKey = "onboarding.photo.title"
        static let photoSubtitle: LocalizedStringKey = "onboarding.photo.subtitle"

        // Step 3: Notification
        static let notificationTitle: LocalizedStringKey = "onboarding.notification.title"
        static let notificationSubtitle: LocalizedStringKey = "onboarding.notification.subtitle"
        static let enableNotifications: LocalizedStringKey = "onboarding.notification.enable"
        static let skipNotification: LocalizedStringKey = "onboarding.notification.skip"
        static let notificationMockTitle: LocalizedStringKey = "onboarding.notification.mock.title"
        static let notificationMockSubtitle: LocalizedStringKey = "onboarding.notification.mock.subtitle"
        static let notificationsEnabled: LocalizedStringKey = "onboarding.notification.enabled"

        // Step 4: Get Started
        static let getStartedTitle: LocalizedStringKey = "onboarding.getStarted.title"
        static let getStartedSubtitle: LocalizedStringKey = "onboarding.getStarted.subtitle"
        static let getStartedButton: LocalizedStringKey = "onboarding.getStarted.button"

        // Step Header
        static func stepIndicator(current: Int, total: Int) -> LocalizedStringKey {
            "onboarding.stepIndicator \(current) \(total)"
        }
    }
}
