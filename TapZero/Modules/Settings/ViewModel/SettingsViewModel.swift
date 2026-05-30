//
//  SettingsViewModel.swift
//  Created by __Username__ on __Date__
//

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
    @ObservedInjected private(set) var languageManager: LanguageManager
    @ObservedInjected private(set) var authManager: AuthManager
    @ObservedInjected private(set) var userManager: UserManager
    @Injected private(set) var crashReporter: CrashReporterProtocol
    @Injected private(set) var eventManager: EventManager

    // MARK: - Published Properties
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
    }
}

// MARK: - Computed Properties
extension SettingsViewModel {
    var selectedLanguage: AppLanguage {
        languageManager.currentLanguage
    }

    var isAnonymous: Bool {
        authManager.auth?.isAnonymous ?? true
    }

    var displayName: String {
        userManager.currentUser?.displayName ?? ""
    }

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
