//
//  KeychainManager.swift
//  TapZero
//

import Foundation
import KeychainAccess

final class KeychainManager: KeychainManagerProtocol {
    private let keychain: Keychain

    init(service: String) {
        self.keychain = Keychain(service: service)
    }

    // MARK: - String

    func set(_ value: String, forKey key: String) {
        keychain[key] = value
    }

    func string(forKey key: String) -> String? {
        keychain[key]
    }

    // MARK: - Bool

    func set(_ value: Bool, forKey key: String) {
        keychain[key] = value ? "1" : "0"
    }

    func bool(forKey key: String) -> Bool {
        keychain[key] == "1"
    }

    // MARK: - Data

    func set(_ value: Data, forKey key: String) {
        keychain[data: key] = value
    }

    func data(forKey key: String) -> Data? {
        try? keychain.getData(key)
    }

    // MARK: - Codable

    func set<T: Encodable>(_ value: T, forKey key: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        keychain[data: key] = data
    }

    func object<T: Decodable>(forKey key: String) -> T? {
        guard let data = try? keychain.getData(key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    // MARK: - RawRepresentable Convenience

    func set(_ value: String, forKey key: some RawRepresentable<String>) {
        set(value, forKey: key.rawValue)
    }

    func string(forKey key: some RawRepresentable<String>) -> String? {
        string(forKey: key.rawValue)
    }

    func set(_ value: Bool, forKey key: some RawRepresentable<String>) {
        set(value, forKey: key.rawValue)
    }

    func bool(forKey key: some RawRepresentable<String>) -> Bool {
        bool(forKey: key.rawValue)
    }

    func set(_ value: Data, forKey key: some RawRepresentable<String>) {
        set(value, forKey: key.rawValue)
    }

    func data(forKey key: some RawRepresentable<String>) -> Data? {
        data(forKey: key.rawValue)
    }

    func set<T: Encodable>(_ value: T, forKey key: some RawRepresentable<String>) {
        set(value, forKey: key.rawValue)
    }

    func object<T: Decodable>(forKey key: some RawRepresentable<String>) -> T? {
        object(forKey: key.rawValue)
    }

    // MARK: - Remove

    func remove(forKey key: String) {
        keychain[key] = nil
    }

    func remove(forKey key: some RawRepresentable<String>) {
        remove(forKey: key.rawValue)
    }

    func removeAll() {
        try? keychain.removeAll()
    }
}
