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
            let result = try await authManager.signInApple()
            try await userManager.logIn(auth: result.user, isNewUser: result.isNewUser, displayName: entity.displayName)
            try? await userManager.markOnboardingCompleteForCurrentUser()
            keychainManager.set(true, forKey: SecureStorageKey.hasCompletedOnboardingBefore)
            sendEvent(type: .completedSignIn(provider: "apple"))
            completeSignIn()
        } catch {
            crashReporter.record(error: error)
            sendEvent(type: .failedSignIn(provider: "apple", error: error.localizedDescription))
            showError(error)
        }
    }

    func signInWithGoogle() async {
        do {
            let result = try await authManager.signInGoogle()
            try await userManager.logIn(auth: result.user, isNewUser: result.isNewUser, displayName: entity.displayName)
            try? await userManager.markOnboardingCompleteForCurrentUser()
            keychainManager.set(true, forKey: SecureStorageKey.hasCompletedOnboardingBefore)
            sendEvent(type: .completedSignIn(provider: "google"))
            completeSignIn()
        } catch {
            crashReporter.record(error: error)
            sendEvent(type: .failedSignIn(provider: "google", error: error.localizedDescription))
            showError(error)
        }
    }

    func completeAsGuest() {
        Task {
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
        } else {
            navigateToTabbar()
        }
    }
}
