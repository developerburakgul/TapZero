//
//  FirebaseRemoteUserService.swift
//  TapZero
//

import FirebaseFirestore
import SwiftfulFirestore

@MainActor
struct FirebaseRemoteUserService: RemoteUserServiceProtocol {
    private var usersCollection: CollectionReference {
        Firestore.firestore().collection("users")
    }

    func saveUser(user: UserModel) async throws {
        try await usersCollection.setDocument(id: user.userId, document: user)
    }

    func markOnboardingCompleted(userId: String) async throws {
        let dict: [String: Any] = [
            UserModel.CodingKeys.didCompleteOnboarding.rawValue: true
        ]
        try await usersCollection.updateDocument(id: userId, dict: dict)
    }

    func updateDisplayName(userId: String, name: String) async throws {
        let dict: [String: Any] = [
            UserModel.CodingKeys.displayName.rawValue: name
        ]
        try await usersCollection.updateDocument(id: userId, dict: dict)
    }

    func updateProfileImageURL(userId: String, url: String?) async throws {
        let dict: [String: Any?] = [
            UserModel.CodingKeys.profileImageURL.rawValue: url
        ]
        try await usersCollection.updateDocument(id: userId, dict: dict.compactMapValues { $0 })
    }

    func streamUser(userId: String) -> AsyncThrowingStream<UserModel, Error> {
        usersCollection.streamDocument(id: userId)
    }

    func deleteUser(userId: String) async throws {
        try await usersCollection.deleteDocument(id: userId)
    }
}
