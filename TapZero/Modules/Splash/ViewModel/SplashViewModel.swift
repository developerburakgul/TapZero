//
//  SplashViewModel.swift
//  Created by __Username__ on __Date__
//

import Combine
import SwiftfulRouting
import SwiftUI

@MainActor
final class SplashViewModel: ObservableObject {
    // MARK: - Non-Published Properties
    var didAppearOnce: Bool = false
    let router: Router
    let entity: SplashEntity

    // MARK: - Managers
    @Injected private(set) var authManager: AuthManager
    @Injected private(set) var userManager: UserManager
    @Injected private(set) var remoteConfigManager: RemoteConfigManager
    @Injected private(set) var keychainManager: KeychainManagerProtocol
    @Injected private(set) var gameManager: GameManager
    @Injected private(set) var crashReporter: CrashReporterProtocol
    @Injected private(set) var eventManager: EventManager

    // MARK: - Published Properties
    @Published var isForceUpdatePresented: Bool = false
    var userLoadFailed = false

    // MARK: - Subview Entities

    // MARK: - Init
    init(
        router: Router,
        entity: SplashEntity
    ) {
        self.router = router
        self.entity = entity
    }
}

// MARK: - Computed Properties
extension SplashViewModel {
}
