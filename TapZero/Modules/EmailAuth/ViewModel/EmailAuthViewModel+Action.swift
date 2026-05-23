//
//  EmailAuthViewModel+Action.swift
//  TapZero
//

import Foundation
import SwiftfulRouting
import SwiftUI

// MARK: - Actions
extension EmailAuthViewModel {
    func viewDidLoad() async {}

    func viewWillAppear() async {
        sendEvent(type: .pageAppear)
    }

    func didTapSubmit() {
        guard !isLoading else { return }
        isLoading = true
        Task {
            if isSignUp {
                sendEvent(type: .submittedCreateAccount)
                await createAccount()
            } else {
                sendEvent(type: .submittedSignIn)
                await signIn()
            }
            isLoading = false
        }
    }

    func didTapToggleMode() {
        isSignUp.toggle()
    }

    // MARK: - Error

    func showError(_ error: Error) {
        router.showAlert(
            alert: AnyAlert(
                title: TextKey.Common.errorTitle,
                subtitle: error.localizedDescription
            ) {
                Button(TextKey.Common.ok, role: .cancel) {}
            }
        )
    }

    // MARK: - Navigation

    func navigateToTabbar() {
        let entity = TabbarEntity(initialTab: userManager.lastSelectedTab())
        router.showModule(.identity, id: "tabbar") { _ in
            RouterView(addNavigationStack: false) { router in
                TabbarBuilder.build(router: router, entity: entity)
            }
        }
    }

    func navigateToOnboarding() {
        router.showModule(.identity, id: "onboarding") { _ in
            RouterView(addNavigationStack: true) { router in
                OnboardingBuilder.build(router: router)
            }
        }
    }
}
