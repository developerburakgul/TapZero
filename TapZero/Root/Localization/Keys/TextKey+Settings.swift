//
//  TextKey+Settings.swift
//  Created by __Username__ on __Date__
//

import SwiftUI

extension TextKey {
    enum Settings {
        static let appSettings: LocalizedStringKey = "settings.appSettings"
        static let appearance: LocalizedStringKey = "settings.appearance"
        static let language: LocalizedStringKey = "settings.language"
        static let about: LocalizedStringKey = "settings.about"
        static let version: LocalizedStringKey = "settings.version"
        static let rateApp: LocalizedStringKey = "settings.rateApp"
        static let shareApp: LocalizedStringKey = "settings.shareApp"
        static let privacyPolicy: LocalizedStringKey = "settings.privacyPolicy"
        static let termsOfService: LocalizedStringKey = "settings.termsOfService"

        // Provider
        static var providerEmailValue: String { TextKey.localized("settings.provider.email") }

        // Notifications
        static let notifications: LocalizedStringKey = "settings.notifications"
        static let notificationEnabled: LocalizedStringKey = "settings.notifications.enabled"
        static let notificationDisabled: LocalizedStringKey = "settings.notifications.disabled"
        static let notificationFooter: LocalizedStringKey = "settings.notifications.footer"
        static let notificationGoToSettings: LocalizedStringKey = "settings.notifications.goToSettings"
        static let notificationAskLater: LocalizedStringKey = "settings.notifications.askLater"
        static let notificationSettingsPath: LocalizedStringKey = "settings.notifications.settingsPath"

        // Account
        static let account: LocalizedStringKey = "settings.account"
        static let guest: LocalizedStringKey = "settings.guest"
        static let signIn: LocalizedStringKey = "settings.signIn"
        static let signUp: LocalizedStringKey = "settings.signUp"
        static let signInWithApple: LocalizedStringKey = "settings.signInWithApple"
        static let signInWithGoogle: LocalizedStringKey = "settings.signInWithGoogle"
        static let signOut: LocalizedStringKey = "settings.signOut"
        static let deleteAccount: LocalizedStringKey = "settings.deleteAccount"
        static let deleteData: LocalizedStringKey = "settings.deleteData"
        static let cancel: LocalizedStringKey = "settings.cancel"

        // Sign Out Alert
        static var signOutAlertTitle: String { TextKey.localized("settings.signOut.alert.title") }
        static var signOutAlertMessage: String { TextKey.localized("settings.signOut.alert.message") }
        static var signOutAlertConfirm: String { TextKey.localized("settings.signOut.alert.confirm") }

        // Delete Account Alert
        static var deleteAccountAlertTitle: String { TextKey.localized("settings.deleteAccount.alert.title") }
        static var deleteAccountAlertMessage: String { TextKey.localized("settings.deleteAccount.alert.message") }
        static var deleteAccountAlertConfirm: String { TextKey.localized("settings.deleteAccount.alert.confirm") }

        // Delete Data Alert
        static var deleteDataAlertTitle: String { TextKey.localized("settings.deleteData.alert.title") }
        static var deleteDataAlertMessage: String { TextKey.localized("settings.deleteData.alert.message") }
        static var deleteDataAlertConfirm: String { TextKey.localized("settings.deleteData.alert.confirm") }

        enum Theme {
            static let system: LocalizedStringKey = "settings.theme.system"
            static let light: LocalizedStringKey = "settings.theme.light"
            static let dark: LocalizedStringKey = "settings.theme.dark"
        }
    }
}
