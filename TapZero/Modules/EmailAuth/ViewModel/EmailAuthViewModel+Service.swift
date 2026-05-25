//
//  EmailAuthViewModel+Service.swift
//  TapZero
//

import Foundation

// MARK: - Service
extension EmailAuthViewModel {
    func createAccount() async {
        do {
            let result = try await authManager.createAccountEmail(email: email, password: password)
            try await userManager.logIn(auth: result.user, isNewUser: result.isNewUser)
            if !entity.isSignIn {
                try? await userManager.markOnboardingCompleteForCurrentUser()
            }
            keychainManager.set(true, forKey: SecureStorageKey.hasCompletedOnboardingBefore)

            if userManager.currentUser?.didCompleteOnboarding == true {
                navigateToTabbar()
            } else {
                navigateToOnboarding()
            }
        } catch {
            crashReporter.record(error: error)
            showError(error)
        }
    }

    func signIn() async {
        do {
            let result = try await authManager.signInEmail(email: email, password: password)
            try await userManager.logIn(auth: result.user, isNewUser: result.isNewUser)
            keychainManager.set(true, forKey: SecureStorageKey.hasCompletedOnboardingBefore)

            if userManager.currentUser?.didCompleteOnboarding == true {
                navigateToTabbar()
            } else {
                navigateToOnboarding()
            }
        } catch {
            crashReporter.record(error: error)
            showError(error)
        }
    }
}
