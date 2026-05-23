//
//  RemoteConfigServiceProtocol.swift
//  TapZero
//
//  Created by Burak Gül on 18.03.2026.
//

import Foundation

protocol RemoteConfigServiceProtocol {
    func fetch() async throws
    func string(forKey key: String) -> String?
    func bool(forKey key: String) -> Bool
    func int(forKey key: String) -> Int?
    func double(forKey key: String) -> Double?
    func json(forKey key: String) -> Data?
}
