//
//  CreateAccountViewModel.swift
//  TapZero
//

import Combine
import SwiftfulRouting
import SwiftUI

@MainActor
final class CreateAccountViewModel: ObservableObject {
    // MARK: - Non-Published Properties
    var didAppearOnce: Bool = false
    let router: Router
    let entity: CreateAccountEntity
    let onComplete: (@MainActor () -> Void)?

    // MARK: - Managers
    @Injected private(set) var authManager: AuthManager
    @Injected private(set) var userManager: UserManager
    @Injected private(set) var keychainManager: KeychainManagerProtocol
    @Injected private(set) var crashReporter: CrashReporterProtocol
    @Injected private(set) var eventManager: EventManager

    // MARK: - Published Properties
    @Published var isLoading: Bool = false

    // MARK: - Init
    init(
        router: Router,
        entity: CreateAccountEntity,
        onComplete: (@MainActor () -> Void)? = nil
    ) {
        self.router = router
        self.entity = entity
        self.onComplete = onComplete
    }
}

// MARK: - Computed Properties
extension CreateAccountViewModel {
}
