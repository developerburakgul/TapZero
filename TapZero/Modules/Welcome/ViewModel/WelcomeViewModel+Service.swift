//
//  WelcomeViewModel+Service.swift
//  TapZero
//

import Foundation

// MARK: - Service
extension WelcomeViewModel {
    func signInAnonymouslyAndNavigate() async {
        do {
            let result = try await authManager.signInAnonymously()
            try await userManager.logIn(auth: result.user, isNewUser: result.isNewUser)
            navigateToOnboarding()
        } catch {
            crashReporter.record(error: error)
            showError(error)
        }
    }
}
