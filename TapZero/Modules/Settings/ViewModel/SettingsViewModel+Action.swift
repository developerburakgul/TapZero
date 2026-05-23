//
//  SettingsViewModel+Action.swift
//  Created by __Username__ on __Date__
//

import DynamicColor
import Foundation
import SwiftfulRouting
import SwiftUI

// MARK: - Actions
extension SettingsViewModel {
    /// Called from .task modifier — first appear only (viewDidLoad)
    func viewDidLoad() async {
        await sendInitialRequests()
    }

    /// Called from .task modifier — every appear (viewWillAppear)
    func viewWillAppear() async {
        await configure()
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

    func didTapAppearance() {
        let config = ResizableSheetConfig(
            detents: [.fraction(0.3)],
            dragIndicator: .visible
        )
        router.showScreen(.sheetConfig(config: config)) { _ in
            AppearancePickerScreen(themeStore: ThemeStore.shared)
        }
    }

    func didTapNotification() {
        let config = ResizableSheetConfig(
            detents: [.large],
            dragIndicator: .visible
        )
        router.showScreen(.sheetConfig(config: config)) { sheetRouter in
            NotificationPermissionScreen {
                sheetRouter.dismissScreen()
            }
        }
    }

    func didTapLanguage() {
        let config = ResizableSheetConfig(
            detents: [.large],
            dragIndicator: .visible
        )
        router.showScreen(.sheetConfig(config: config)) { [weak self] _ in
            LanguagePickerScreen(
                selectedLanguage: Binding(
                    get: { self?.selectedLanguage ?? .english },
                    set: { _ in }
                )
            ) { language in
                self?.onLanguageSelected(language)
            }
        }
    }

    func onLanguageSelected(_ language: AppLanguage) {
        sendEvent(type: .changedLanguage(language: language.rawValue))
        languageManager.currentLanguage = language
    }

    func didTapSignIn() {
        sendEvent(type: .tappedSignIn)
        let config = ResizableSheetConfig(
            detents: [.medium],
            dragIndicator: .visible
        )
        router.showScreen(.sheetConfig(config: config)) { router in
            CreateAccountBuilder.build(
                router: router,
                entity: CreateAccountEntity(showGuestOption: false, dismissOnComplete: true)
            )
        }
    }

    func didTapSignOut() {
        sendEvent(type: .tappedSignOut)
        router.showAlert(
            alert: AnyAlert(
                title: TextKey.Settings.signOutAlertTitle,
                subtitle: TextKey.Settings.signOutAlertMessage
            ) {
                Button(TextKey.Settings.signOutAlertConfirm, role: .destructive) {
                    self.performSignOut()
                }
                Button(TextKey.Settings.cancel, role: .cancel) {}
            }
        )
    }

    func didTapDeleteAccount() {
        sendEvent(type: .tappedDeleteAccount)
        router.showAlert(
            alert: AnyAlert(
                title: TextKey.Settings.deleteAccountAlertTitle,
                subtitle: TextKey.Settings.deleteAccountAlertMessage
            ) {
                Button(TextKey.Settings.deleteAccountAlertConfirm, role: .destructive) {
                    Task {
                        await self.performDeleteAccount()
                    }
                }
                Button(TextKey.Settings.cancel, role: .cancel) {}
            }
        )
    }

    func didTapDeleteData() {
        router.showAlert(
            alert: AnyAlert(
                title: TextKey.Settings.deleteDataAlertTitle,
                subtitle: TextKey.Settings.deleteDataAlertMessage
            ) {
                Button(TextKey.Settings.deleteDataAlertConfirm, role: .destructive) {
                    Task {
                        await self.performDeleteAccount()
                    }
                }
                Button(TextKey.Settings.cancel, role: .cancel) {}
            }
        )
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

    func navigateToWelcome() {
        let targetRouter = appRouter ?? router
        targetRouter.showModule(.identity, id: "welcome") { _ in
            RouterView(addNavigationStack: true) { router in
                WelcomeBuilder.build(router: router)
            }
        }
    }
}
