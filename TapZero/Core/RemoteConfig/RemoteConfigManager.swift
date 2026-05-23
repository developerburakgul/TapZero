//
//  RemoteConfigManager.swift
//  TapZero
//
//  Created by Burak Gül on 18.03.2026.
//

import Foundation

final class RemoteConfigManager {
    private let service: RemoteConfigServiceProtocol

    init(service: RemoteConfigServiceProtocol) {
        self.service = service
    }

    // MARK: - Fetch

    func fetch() async throws {
        try await service.fetch()
    }

    // MARK: - Accessors

    func string(forKey key: some RawRepresentable<String>) -> String? {
        service.string(forKey: key.rawValue)
    }

    func bool(forKey key: some RawRepresentable<String>) -> Bool {
        service.bool(forKey: key.rawValue)
    }

    func int(forKey key: some RawRepresentable<String>) -> Int? {
        service.int(forKey: key.rawValue)
    }

    func double(forKey key: some RawRepresentable<String>) -> Double? {
        service.double(forKey: key.rawValue)
    }

    func json(forKey key: some RawRepresentable<String>) -> Data? {
        service.json(forKey: key.rawValue)
    }
}
