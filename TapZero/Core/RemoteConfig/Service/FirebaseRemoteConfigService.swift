//
//  FirebaseRemoteConfigService.swift
//  TapZero
//
//  Created by Burak Gül on 18.03.2026.
//

import FirebaseRemoteConfig
import Foundation

final class FirebaseRemoteConfigService: RemoteConfigServiceProtocol {
    private let remoteConfig = RemoteConfig.remoteConfig()

    init() {
        let settings = RemoteConfigSettings()
        #if DEV
        settings.minimumFetchInterval = 0
        #else
        settings.minimumFetchInterval = 3600
        #endif
        remoteConfig.configSettings = settings
    }

    func fetch() async throws {
        try await remoteConfig.fetchAndActivate()
    }

    func string(forKey key: String) -> String? {
        let value = remoteConfig.configValue(forKey: key).stringValue
        return value.isEmpty ? nil : value
    }

    func bool(forKey key: String) -> Bool {
        remoteConfig.configValue(forKey: key).boolValue
    }

    func int(forKey key: String) -> Int? {
        let value = remoteConfig.configValue(forKey: key)
        guard value.source != .static else { return nil }
        return value.numberValue.intValue
    }

    func double(forKey key: String) -> Double? {
        let value = remoteConfig.configValue(forKey: key)
        guard value.source != .static else { return nil }
        return value.numberValue.doubleValue
    }

    func json(forKey key: String) -> Data? {
        remoteConfig.configValue(forKey: key).dataValue
    }
}
