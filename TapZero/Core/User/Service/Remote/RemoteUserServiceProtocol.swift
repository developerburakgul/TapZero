//
//  RemoteUserServiceProtocol.swift
//  TapZero
//

import Foundation

@MainActor
protocol RemoteUserServiceProtocol: Sendable {
    func saveUser(user: UserModel) async throws
    func markOnboardingCompleted(userId: String) async throws
    func updateProfileImageURL(userId: String, url: String?) async throws
    func streamUser(userId: String) -> AsyncThrowingStream<UserModel, Error>
    func deleteUser(userId: String) async throws
}
