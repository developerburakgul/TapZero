//
//  SettingsViewModel+Service.swift
//  Created by __Username__ on __Date__
//

import Foundation

// MARK: - Service
extension SettingsViewModel {
    func fetchData() async {}

    func upgradeToApple() async {
        do {
            let result = try await authManager.signInApple()
            try await userManager.logIn(auth: result.user, isNewUser: result.isNewUser)
        } catch {
            crashReporter.record(error: error)
            showError(error)
        }
    }

    func upgradeToGoogle() async {
        do {
            let result = try await authManager.signInGoogle()
            try await userManager.logIn(auth: result.user, isNewUser: result.isNewUser)
        } catch {
            crashReporter.record(error: error)
            showError(error)
        }
    }

    func performSignOut() {
        do {
            userManager.clearLastSelectedTab()
            try authManager.signOut()
            userManager.signOut()
            sendEvent(type: .completedSignOut)
            navigateToWelcome()
        } catch {
            crashReporter.record(error: error)
            showError(error)
        }
    }

    func performDeleteAccount() async {
        do {
            userManager.clearLastSelectedTab()
            try await userManager.deleteCurrentUser()
            try await authManager.deleteAccount()
            sendEvent(type: .completedDeleteAccount)
            navigateToWelcome()
        } catch {
            crashReporter.record(error: error)
            showError(error)
        }
    }
}
