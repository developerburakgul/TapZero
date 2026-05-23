//
//  MockRemoteUserService.swift
//  TapZero
//

import Combine
import Foundation

@MainActor
class MockRemoteUserService: RemoteUserServiceProtocol {
    @Published var currentUser: UserModel?

    init(user: UserModel? = nil) {
        self.currentUser = user
    }

    func saveUser(user: UserModel) async throws {
        currentUser = user
    }

    func markOnboardingCompleted(userId: String) async throws {
        guard let user = currentUser, user.userId == userId else { return }
        currentUser = UserModel(
            userId: user.userId,
            email: user.email,
            displayName: user.displayName,
            isAnonymous: user.isAnonymous,
            creationDate: user.creationDate,
            creationVersion: user.creationVersion,
            lastSignInDate: user.lastSignInDate,
            didCompleteOnboarding: true,
            profileColorHex: user.profileColorHex,
            profileImageURL: user.profileImageURL
        )
    }

    func updateProfileImageURL(userId: String, url: String?) async throws {
        guard let user = currentUser, user.userId == userId else { return }
        currentUser = UserModel(
            userId: user.userId,
            email: user.email,
            displayName: user.displayName,
            isAnonymous: user.isAnonymous,
            creationDate: user.creationDate,
            creationVersion: user.creationVersion,
            lastSignInDate: user.lastSignInDate,
            didCompleteOnboarding: user.didCompleteOnboarding,
            profileColorHex: user.profileColorHex,
            profileImageURL: url
        )
    }

    func streamUser(userId: String) -> AsyncThrowingStream<UserModel, Error> {
        AsyncThrowingStream { continuation in
            if let currentUser {
                continuation.yield(currentUser)
            }

            Task { [weak self] in
                guard let self else {
                    continuation.finish()
                    return
                }
                for await user in $currentUser.values {
                    if let user {
                        continuation.yield(user)
                    }
                }
                continuation.finish()
            }
        }
    }

    func deleteUser(userId: String) async throws {
        currentUser = nil
    }
}
