//
//  LocalUserPersistenceProtocol.swift
//  TapZero
//

import Foundation

protocol LocalUserPersistenceProtocol: Sendable {
    func getCurrentUser() -> UserModel?
    func saveCurrentUser(user: UserModel?) throws
}
