//
//  AuthManager.swift
//  TapZero
//

import Combine
import SwiftUI

@MainActor
final class AuthManager: ObservableObject {
    private let service: AuthServiceProtocol
    @Injected private var crashReporter: CrashReporterProtocol
    @Published private(set) var auth: UserAuthInfo?
    private var listener: (any NSObjectProtocol)?

    init(service: AuthServiceProtocol) {
        self.service = service
        self.auth = service.getAuthenticatedUser()
        self.addAuthListener()
    }

    private func addAuthListener() {
        if let listener {
            service.removeAuthenticatedUserListener(listener: listener)
        }

        Task {
            for await value in service.addAuthenticatedUserListener(onListenerAttached: { listener in
                self.listener = listener
            }) {
                self.auth = value
                self.crashReporter.setUserId(value?.uid)
            }
        }
    }

    func getAuthId() throws -> String {
        guard let uid = auth?.uid else {
            throw AuthError.notSignedIn
        }
        return uid
    }

    func signInAnonymously() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        let result = try await service.signInAnonymously()
        self.auth = result.user
        return result
    }

    func signInApple() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        defer { addAuthListener() }
        let result = try await service.signInApple()
        self.auth = result.user
        return result
    }

    func signInGoogle() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        defer { addAuthListener() }
        let result = try await service.signInGoogle()
        self.auth = result.user
        return result
    }

    func signInEmail(email: String, password: String) async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        defer { addAuthListener() }
        let result = try await service.signInEmail(email: email, password: password)
        self.auth = result.user
        return result
    }

    func createAccountEmail(email: String, password: String) async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        defer { addAuthListener() }
        let result = try await service.createAccountEmail(email: email, password: password)
        self.auth = result.user
        return result
    }

    func signOut() throws {
        try service.signOut()
        auth = nil
        crashReporter.setUserId(nil)
    }

    func deleteAccount() async throws {
        try await service.deleteAccount()
        auth = nil
        crashReporter.setUserId(nil)
    }

    enum AuthError: LocalizedError {
        case notSignedIn
    }
}
