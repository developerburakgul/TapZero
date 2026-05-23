//
//  MockRemoteConfigService.swift
//  TapZero
//
//  Created by Burak Gül on 18.03.2026.
//

import Foundation

class MockRemoteConfigService: RemoteConfigServiceProtocol {
    private var values: [String: String]

    init(values: [String: String] = [:]) {
        self.values = values
    }

    func fetch() async throws {}

    func string(forKey key: String) -> String? {
        values[key]
    }

    func bool(forKey key: String) -> Bool {
        values[key] == "true"
    }

    func int(forKey key: String) -> Int? {
        values[key].flatMap { Int($0) }
    }

    func double(forKey key: String) -> Double? {
        values[key].flatMap { Double($0) }
    }

    func json(forKey key: String) -> Data? {
        values[key]?.data(using: .utf8)
    }
}
