//
//  SplashViewModel+Action.swift
//  Created by __Username__ on __Date__
//

import Foundation
import SwiftfulRouting
import SwiftUI

// MARK: - Actions
extension SplashViewModel {
    /// Called from .task modifier — first appear only (viewDidLoad)
    func viewDidLoad() async {
        await sendInitialRequests()
    }

    /// Called from .task modifier — every appear (viewWillAppear)
    func viewWillAppear() async {
        configure()
        sendEvent(type: .pageAppear)
    }

    func sendInitialRequests() async {
        await withTaskGroup { group in
            group.addTask {
                try? await Task.sleep(for: .seconds(2))
            }
            group.addTask {
                await self.fetchRemoteConfig()
            }
            group.addTask {
                await self.loadExistingUser()
            }
        }

        sendEvent(type: .completedRouting)
        if let info = forceUpdateInfo() {
            showForceUpdateModal(entity: info)
        } else {
            await navigateAfterSplash()
        }
    }

    // MARK: - Force Update

    private func showForceUpdateModal(entity: ForceUpdateEntity) {
        isForceUpdatePresented = true

        let gradient = LinearGradient(
            colors: [
                TapZeroDesign.ForceUpdate.sheetGradientStart,
                TapZeroDesign.ForceUpdate.sheetGradientEnd
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        let sheetConfig = ResizableSheetConfig(
            detents: [.fraction(0.65)],
            dragIndicator: .hidden,
            background: .custom(gradient),
            cornerRadius: 24
        )
        router.showScreen(
            .sheetConfig(config: sheetConfig),
            id: "forceUpdate"
        ) { router in
            ForceUpdateBuilder.build(router: router, entity: entity)
                .interactiveDismissDisabled(true)
        }
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

    private func navigateAfterSplash() async {
        if authManager.auth != nil, userLoadFailed {
            showLoadFailedAlert()
        } else if authManager.auth != nil, userManager.currentUser?.didCompleteOnboarding == true {
            navigateToTabbar()
        } else if authManager.auth != nil {
            navigateToOnboarding()
        } else if keychainManager.bool(forKey: SecureStorageKey.hasCompletedOnboardingBefore) {
            navigateToWelcome()
        } else {
            await signInAnonymouslyAndNavigate()
        }
    }

    private func showLoadFailedAlert() {
        router.showAlert(
            alert: AnyAlert(
                title: TextKey.Common.errorTitle,
                subtitle: TextKey.Common.loadFailed
            ) {
                Button(TextKey.Common.retry) {
                    Task {
                        self.userLoadFailed = false
                        await self.loadExistingUser()
                        await self.navigateAfterSplash()
                    }
                }
            }
        )
    }

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

    private func navigateToWelcome() {
        router.showModule(.identity, id: "welcome") { _ in
            RouterView(addNavigationStack: true) { router in
                WelcomeBuilder.build(router: router)
            }
        }
    }
}
