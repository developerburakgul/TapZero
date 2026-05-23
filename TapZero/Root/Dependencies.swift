//
//  Dependencies.swift
//  TapZero
//
//  Created by Burak Gül on 9.03.2026.
//

import DependencyContainer
import Foundation
import SwiftUI

@MainActor
struct Dependencies {
    // swiftlint:disable:next implicitly_unwrapped_optional
    static var shared: Self!

    let container: DependencyContainer
    var rootRouter: Router?

    init(config: BuildConfiguration) {
        let container = DependencyContainer()

        // Language
        let languageManager = LanguageManager()
        container.register(LanguageManager.self, service: languageManager)

        // DeepLink
        let deepLinkManager = DeepLinkManager()
        container.register(DeepLinkManager.self, service: deepLinkManager)

        // Set shared early so @Injected works inside manager inits
        self.container = container
        Self.shared = self

        switch config {
        case .mock(let isSignedIn):
            Self.registerMockServices(container: container, isSignedIn: isSignedIn)
        case .dev, .prod:
            Self.registerFirebaseServices(container: container)
        }
    }

    // MARK: - Private Registration

    private static func registerMockServices(container: DependencyContainer, isSignedIn: Bool) {
        // NetworkMonitor
        container.register(NetworkMonitorManager.self, service: NetworkMonitorManager(service: MockNetworkMonitor()))
        // Event
        container.register(EventManager.self, service: EventManager(ga4: MockGA4EventService()))
        // Keychain
        container.register(KeychainManagerProtocol.self, service: MockKeychainManager())
        // CrashReporter
        container.register(CrashReporterProtocol.self, service: MockCrashReporter())
        // Auth
        let mockAuth: UserAuthInfo? = isSignedIn ? .mock() : nil
        container.register(AuthManager.self, service: AuthManager(service: MockAuthService(user: mockAuth)))
        // Storage
        let storageService: StorageServiceProtocol = MockStorageService()
        container.register(StorageServiceProtocol.self, service: storageService)
        // User
        let mockUser: UserModel? = isSignedIn ? .mock : nil
        container.register(UserManager.self, service: UserManager(
            remote: MockRemoteUserService(user: mockUser),
            local: MockLocalUserPersistence(user: mockUser),
            storage: storageService
        ))
        // RemoteConfig
        container.register(RemoteConfigManager.self, service: RemoteConfigManager(
            service: MockRemoteConfigService(values: [RemoteConfigKey.minAppVersion.rawValue: "26.3.0"])
        ))
        // Game
        container.register(GameManager.self, service: GameManager(service: MockGameService()))
    }

    private static func registerFirebaseServices(container: DependencyContainer) {
        // NetworkMonitor
        container.register(NetworkMonitorManager.self, service: NetworkMonitorManager(service: NWPathNetworkMonitor()))
        // Event
        container.register(EventManager.self, service: EventManager(ga4: FirebaseGA4EventService()))
        // Keychain
        let keychainManager = KeychainManager(service: AppConstants.keychainService)
        container.register(KeychainManagerProtocol.self, service: keychainManager)
        // CrashReporter
        container.register(CrashReporterProtocol.self, service: FirebaseCrashReporter())
        // Auth
        container.register(AuthManager.self, service: AuthManager(service: FirebaseAuthService()))
        // Storage
        let storageService: StorageServiceProtocol = FirebaseStorageService()
        container.register(StorageServiceProtocol.self, service: storageService)
        // User
        container.register(UserManager.self, service: UserManager(
            remote: FirebaseRemoteUserService(),
            local: FileManagerUserPersistence(),
            storage: storageService
        ))
        // RemoteConfig
        let remoteConfigManager = RemoteConfigManager(service: FirebaseRemoteConfigService())
        container.register(RemoteConfigManager.self, service: remoteConfigManager)
        // Game
        container.register(GameManager.self, service: GameManager(service: FirebaseGameService()))
    }
}

// MARK: - Preview Helpers

extension View {
    func previewEnvironment() -> some View {
        self
    }
}

@MainActor
class DevPreview {
    static let shared = DevPreview()

    let authManager: AuthManager
    let userManager: UserManager
    let languageManager: LanguageManager
    let eventManager: EventManager
    let networkMonitor: NetworkMonitorManager
    let gameManager: GameManager

    init() {
        // Preview'larda @Injected'ın çalışabilmesi için shared'ı set et
        let dependencies = Dependencies(config: .mock(isSignedIn: true))
        Dependencies.shared = dependencies

        // swiftlint:disable force_unwrapping
        self.authManager = dependencies.container.resolve(AuthManager.self)!
        self.userManager = dependencies.container.resolve(UserManager.self)!
        self.languageManager = dependencies.container.resolve(LanguageManager.self)!
        self.eventManager = dependencies.container.resolve(EventManager.self)!
        self.networkMonitor = dependencies.container.resolve(NetworkMonitorManager.self)!
        self.gameManager = dependencies.container.resolve(GameManager.self)!
        // swiftlint:enable force_unwrapping
    }

    var locale: Locale {
        languageManager.locale
    }
}
