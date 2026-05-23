//
//  MockKeychainManager.swift
//  TapZero
//

import Foundation

final class MockKeychainManager: KeychainManagerProtocol {
    private var storage: [String: Any] = [:]

    // MARK: - String

    func set(_ value: String, forKey key: String) {
        storage[key] = value
    }

    func string(forKey key: String) -> String? {
        storage[key] as? String
    }

    // MARK: - Bool

    func set(_ value: Bool, forKey key: String) {
        storage[key] = value
    }

    func bool(forKey key: String) -> Bool {
        storage[key] as? Bool ?? false
    }

    // MARK: - Data

    func set(_ value: Data, forKey key: String) {
        storage[key] = value
    }

    func data(forKey key: String) -> Data? {
        storage[key] as? Data
    }

    // MARK: - Codable

    func set<T: Encodable>(_ value: T, forKey key: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        storage[key] = data
    }

    func object<T: Decodable>(forKey key: String) -> T? {
        guard let data = storage[key] as? Data else { return nil }
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
        storage[key] = nil
    }

    func remove(forKey key: some RawRepresentable<String>) {
        remove(forKey: key.rawValue)
    }

    func removeAll() {
        storage.removeAll()
    }
}
