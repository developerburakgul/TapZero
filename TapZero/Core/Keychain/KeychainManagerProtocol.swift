//
//  KeychainManagerProtocol.swift
//  TapZero
//

import Foundation

protocol KeychainManagerProtocol {
    // MARK: - String
    func set(_ value: String, forKey key: String)
    func set(_ value: String, forKey key: some RawRepresentable<String>)
    func string(forKey key: String) -> String?
    func string(forKey key: some RawRepresentable<String>) -> String?

    // MARK: - Bool
    func set(_ value: Bool, forKey key: String)
    func set(_ value: Bool, forKey key: some RawRepresentable<String>)
    func bool(forKey key: String) -> Bool
    func bool(forKey key: some RawRepresentable<String>) -> Bool

    // MARK: - Data
    func set(_ value: Data, forKey key: String)
    func set(_ value: Data, forKey key: some RawRepresentable<String>)
    func data(forKey key: String) -> Data?
    func data(forKey key: some RawRepresentable<String>) -> Data?

    // MARK: - Codable
    func set<T: Encodable>(_ value: T, forKey key: String)
    func set<T: Encodable>(_ value: T, forKey key: some RawRepresentable<String>)
    func object<T: Decodable>(forKey key: String) -> T?
    func object<T: Decodable>(forKey key: some RawRepresentable<String>) -> T?

    // MARK: - Remove
    func remove(forKey key: String)
    func remove(forKey key: some RawRepresentable<String>)
    func removeAll()
}
