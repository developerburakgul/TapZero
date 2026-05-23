//
//  SettingsViewModel.swift
//  Created by __Username__ on __Date__
//

import Combine
import SwiftfulRouting
import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    // MARK: - Non-Published Properties
    var didAppearOnce: Bool = false
    let router: Router
    let appRouter: Router?
    let entity: SettingsEntity

    // MARK: - Managers
    @Injected private(set) var languageManager: LanguageManager
    @Injected private(set) var authManager: AuthManager
    @Injected private(set) var userManager: UserManager
    @Injected private(set) var crashReporter: CrashReporterProtocol
    @Injected private(set) var eventManager: EventManager

    // MARK: - Published Properties
    @Published var selectedLanguage: AppLanguage = .english
    @Published var isAnonymous: Bool = true
    @Published var displayName: String = ""
    @Published var notificationEnabled: Bool = false

    // MARK: - Init
    init(
        router: Router,
        appRouter: Router? = nil,
        entity: SettingsEntity
    ) {
        self.router = router
        self.appRouter = appRouter
        self.entity = entity

        selectedLanguage = languageManager.currentLanguage
        isAnonymous = authManager.auth?.isAnonymous ?? true

        languageManager.$currentLanguage
            .receive(on: RunLoop.main)
            .assign(to: &$selectedLanguage)

        authManager.$auth
            .receive(on: RunLoop.main)
            .map { $0?.isAnonymous ?? true }
            .assign(to: &$isAnonymous)

        userManager.$currentUser
            .receive(on: RunLoop.main)
            .map { $0?.displayName ?? "" }
            .assign(to: &$displayName)
    }

    // MARK: - Computed Properties

    var userInitial: String {
        if let first = displayName.first {
            return String(first).uppercased()
        }
        return ""
    }

    var authProvider: UserAuthInfo.AuthProvider {
        authManager.auth?.authProvider ?? .anonymous
    }
}
