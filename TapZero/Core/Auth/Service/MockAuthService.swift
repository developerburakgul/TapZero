//
//  MockAuthService.swift
//  TapZero
//

import Combine
import Foundation

@MainActor
class MockAuthService: AuthServiceProtocol {
    @Published var currentUser: UserAuthInfo?

    init(user: UserAuthInfo? = nil) {
        self.currentUser = user
    }

    // swiftlint:disable:next line_length
    func addAuthenticatedUserListener(onListenerAttached: (any NSObjectProtocol) -> Void) -> AsyncStream<UserAuthInfo?> {
        AsyncStream { continuation in
            continuation.yield(currentUser)

            Task {
                for await value in $currentUser.values {
                    continuation.yield(value)
                }
            }
        }
    }

    func removeAuthenticatedUserListener(listener: any NSObjectProtocol) {}

    func getAuthenticatedUser() -> UserAuthInfo? {
        currentUser
    }

    func signInAnonymously() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        let user = UserAuthInfo.mock(isAnonymous: true)
        currentUser = user
        return (user, true)
    }

    func signInApple() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        let user = UserAuthInfo.mock(isAnonymous: false)
        currentUser = user
        return (user, false)
    }

    func signInGoogle() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        let user = UserAuthInfo.mock(isAnonymous: false)
        currentUser = user
        return (user, false)
    }

    func signInEmail(email: String, password: String) async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        let user = UserAuthInfo.mock(isAnonymous: false)
        currentUser = user
        return (user, false)
    }

    func createAccountEmail(email: String, password: String) async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        let user = UserAuthInfo.mock(isAnonymous: false)
        currentUser = user
        return (user, true)
    }

    func signOut() throws {
        currentUser = nil
    }

    func deleteAccount() async throws {
        currentUser = nil
    }
}
