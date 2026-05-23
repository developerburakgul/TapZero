//
//  EmailAuthViewModel.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

@MainActor
final class EmailAuthViewModel: ObservableObject {
    // MARK: - Non-Published Properties
    var didAppearOnce: Bool = false
    let router: Router
    let entity: EmailAuthEntity

    // MARK: - Managers
    @Injected private(set) var authManager: AuthManager
    @Injected private(set) var userManager: UserManager
    @Injected private(set) var keychainManager: KeychainManagerProtocol
    @Injected private(set) var crashReporter: CrashReporterProtocol
    @Injected private(set) var eventManager: EventManager

    // MARK: - Published Properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isSignUp: Bool = true
    @Published var isLoading: Bool = false

    // MARK: - Init
    init(
        router: Router,
        entity: EmailAuthEntity
    ) {
        self.router = router
        self.entity = entity
        self.isSignUp = !entity.isSignIn
    }
}
