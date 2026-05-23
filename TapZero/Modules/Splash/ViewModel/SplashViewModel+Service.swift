//
//  SplashViewModel+Service.swift
//  Created by __Username__ on __Date__
//

import Foundation

// MARK: - Service
extension SplashViewModel {
    func fetchRemoteConfig() async {
        try? await remoteConfigManager.fetch()
    }

    func forceUpdateInfo() -> ForceUpdateEntity? {
        guard let currentVersionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let current = AppVersion(versionString: currentVersionString),
              let minVersionString = remoteConfigManager.string(forKey: RemoteConfigKey.minAppVersion),
              let minimum = AppVersion(versionString: minVersionString),
              current < minimum else {
            return nil
        }
        return ForceUpdateEntity(
            currentVersion: current.versionString,
            requiredVersion: minimum.versionString
        )
    }

    func loadExistingUser(retryCount: Int = 0) async {
        let maxRetry = 3
        guard let auth = authManager.auth else { return }
        do {
            try await userManager.logIn(auth: auth, isNewUser: false)
        } catch {
            crashReporter.record(error: error)
            guard retryCount < maxRetry else { return }
            try? await Task.sleep(for: .seconds(5))
            await loadExistingUser(retryCount: retryCount + 1)
        }
    }

    func signInAnonymouslyAndNavigate() async {
        do {
            let result = try await authManager.signInAnonymously()
            try await userManager.logIn(auth: result.user, isNewUser: result.isNewUser)
            navigateToOnboarding()
        } catch {
            crashReporter.record(error: error)
            showError(error)
        }
    }
}
