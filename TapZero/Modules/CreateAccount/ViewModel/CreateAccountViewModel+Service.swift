//
//  CreateAccountViewModel+Service.swift
//  TapZero
//

import Foundation

// MARK: - Service
extension CreateAccountViewModel {
    func fetchData() async {}

    func signInWithApple() async {
        do {
            let result = try await authManager.signInApple(requireExistingAccount: entity.isSignIn)
            try await userManager.logIn(auth: result.user, isNewUser: result.isNewUser, displayName: entity.displayName)
            if !entity.isSignIn {
                try? await userManager.markOnboardingCompleteForCurrentUser()
            }
            keychainManager.set(true, forKey: SecureStorageKey.hasCompletedOnboardingBefore)
            sendEvent(type: .completedSignIn(provider: "apple"))
            completeSignIn()
        } catch is AuthManager.AuthError {
            showAccountNotFoundError()
        } catch {
            crashReporter.record(error: error)
            sendEvent(type: .failedSignIn(provider: "apple", error: error.localizedDescription))
            showError(error)
        }
    }

    func signInWithGoogle() async {
        do {
            let result = try await authManager.signInGoogle(requireExistingAccount: entity.isSignIn)
            try await userManager.logIn(auth: result.user, isNewUser: result.isNewUser, displayName: entity.displayName)
            if !entity.isSignIn {
                try? await userManager.markOnboardingCompleteForCurrentUser()
            }
            keychainManager.set(true, forKey: SecureStorageKey.hasCompletedOnboardingBefore)
            sendEvent(type: .completedSignIn(provider: "google"))
            completeSignIn()
        } catch is AuthManager.AuthError {
            showAccountNotFoundError()
        } catch {
            crashReporter.record(error: error)
            sendEvent(type: .failedSignIn(provider: "google", error: error.localizedDescription))
            showError(error)
        }
    }

    func completeAsGuest() {
        Task {
            try? await userManager.updateDisplayName(entity.displayName)
            try? await userManager.markOnboardingCompleteForCurrentUser()
            keychainManager.set(true, forKey: SecureStorageKey.hasCompletedOnboardingBefore)
            completeSignIn()
        }
    }

    private func completeSignIn() {
        if let onComplete {
            router.dismissScreen()
            onComplete()
        } else if entity.dismissOnComplete {
            router.dismissScreen()
        } else if userManager.currentUser?.didCompleteOnboarding == true {
            navigateToTabbar()
        } else {
            navigateToOnboarding()
        }
    }
}
