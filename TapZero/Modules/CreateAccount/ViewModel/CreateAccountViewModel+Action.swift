//
//  CreateAccountViewModel+Action.swift
//  TapZero
//

import Foundation
import SwiftfulRouting
import SwiftUI

// MARK: - Actions
extension CreateAccountViewModel {
    func viewDidLoad() async {
        await sendInitialRequests()
    }

    func viewWillAppear() async {
        configure()
        sendEvent(type: .pageAppear)
    }

    func sendInitialRequests() async {
        await withTaskGroup { group in
            group.addTask {
                await self.fetchData()
            }
        }
    }

    // MARK: - User Actions

    func didTapApple() {
        guard !isLoading else { return }
        sendEvent(type: .tappedApple)
        isLoading = true

        Task {
            await signInWithApple()
            isLoading = false
        }
    }

    func didTapGoogle() {
        guard !isLoading else { return }
        sendEvent(type: .tappedGoogle)
        isLoading = true

        Task {
            await signInWithGoogle()
            isLoading = false
        }
    }

    func didTapEmail() {
        sendEvent(type: .tappedEmail)
        let config = ResizableSheetConfig(
            detents: [.medium, .large],
            dragIndicator: .visible
        )
        router.showScreen(.sheetConfig(config: config)) { router in
            EmailAuthBuilder.build(
                router: router,
                entity: EmailAuthEntity(isSignIn: self.entity.isSignIn)
            )
        }
    }

    func didTapGuest() {
        sendEvent(type: .tappedGuest)
        completeAsGuest()
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
}
