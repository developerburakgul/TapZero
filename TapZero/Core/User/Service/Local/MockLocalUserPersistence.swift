//
//  MockLocalUserPersistence.swift
//  TapZero
//

import Foundation

struct MockLocalUserPersistence: LocalUserPersistenceProtocol {
    private let user: UserModel?

    init(user: UserModel? = nil) {
        self.user = user
    }

    func getCurrentUser() -> UserModel? {
        user
    }

    func saveCurrentUser(user: UserModel?) throws {
        // No-op for mock
    }
}
