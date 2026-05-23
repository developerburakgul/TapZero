//
//  WelcomeViewModel.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

@MainActor
final class WelcomeViewModel: ObservableObject {
    // MARK: - Non-Published Properties
    var didAppearOnce: Bool = false
    let router: Router
    let entity: WelcomeEntity

    // MARK: - Managers
    @Injected private(set) var authManager: AuthManager
    @Injected private(set) var userManager: UserManager
    @Injected private(set) var crashReporter: CrashReporterProtocol
    @Injected private(set) var eventManager: EventManager

    // MARK: - Published Properties
    @Published var isLoading: Bool = false

    // MARK: - Init
    init(
        router: Router,
        entity: WelcomeEntity
    ) {
        self.router = router
        self.entity = entity
    }
}
