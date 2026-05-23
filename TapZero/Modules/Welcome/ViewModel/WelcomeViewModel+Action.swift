//
//  WelcomeViewModel+Action.swift
//  TapZero
//

import Foundation
import SwiftfulRouting
import SwiftUI

// MARK: - Actions
extension WelcomeViewModel {
    func viewDidLoad() async {}

    func viewWillAppear() async {
        sendEvent(type: .pageAppear)
    }

    // MARK: - User Actions

    func didTapStart() {
        sendEvent(type: .tappedStartFresh)
        isLoading = true
        Task {
            await signInAnonymouslyAndNavigate()
            isLoading = false
        }
    }

    func didTapSignIn() {
        sendEvent(type: .tappedSignIn)
        navigateToSignIn()
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

    func navigateToSignIn() {
        let config = ResizableSheetConfig(
            detents: [.medium],
            dragIndicator: .visible
        )
        router.showScreen(.sheetConfig(config: config)) { router in
            CreateAccountBuilder.build(
                router: router,
                entity: CreateAccountEntity(showGuestOption: false, isSignIn: true)
            )
        }
    }
}
