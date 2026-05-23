//
//  UserManager.swift
//  Created by __Username__ on __Date__
//

import Combine
import SwiftUI

@MainActor
final class UserManager: ObservableObject {
    private let remote: RemoteUserServiceProtocol
    private let local: LocalUserPersistenceProtocol
    private let storage: StorageServiceProtocol

    @Published private(set) var currentUser: UserModel?
    private var currentUserListenerTask: Task<Void, Never>?

    private let lastTabKey = "lastSelectedTab"

    init(
        remote: RemoteUserServiceProtocol,
        local: LocalUserPersistenceProtocol,
        storage: StorageServiceProtocol
    ) {
        self.remote = remote
        self.local = local
        self.storage = storage
        self.currentUser = local.getCurrentUser()
    }

    // MARK: - Login

    func logIn(auth: UserAuthInfo, isNewUser: Bool, displayName: String = "") async throws {
        if isNewUser || !displayName.isEmpty {
            let creationVersion = isNewUser
                ? Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                : nil
            let user = UserModel(auth: auth, creationVersion: creationVersion, displayName: displayName)
            try await remote.saveUser(user: user)
        }
        addCurrentUserListener(userId: auth.uid)
    }

    // MARK: - Listener

    private func addCurrentUserListener(userId: String) {
        currentUserListenerTask?.cancel()
        currentUserListenerTask = Task {
            do {
                for try await user in remote.streamUser(userId: userId) {
                    self.currentUser = user
                    self.saveCurrentUserLocally()
                }
            } catch {
                // Stream ended or error
            }
        }
    }

    private func saveCurrentUserLocally() {
        try? local.saveCurrentUser(user: currentUser)
    }

    // MARK: - Onboarding

    func markOnboardingCompleteForCurrentUser() async throws {
        guard let userId = currentUser?.userId else { return }
        try await remote.markOnboardingCompleted(userId: userId)
    }

    // MARK: - Profile Image

    func uploadProfileImage(data: Data) async throws {
        guard let userId = currentUser?.userId else { return }
        let path = String(format: AppConstants.profileImagePath, userId)
        let url = try await storage.uploadImage(data: data, path: path)
        try await remote.updateProfileImageURL(userId: userId, url: url.absoluteString)
    }

    func deleteProfileImage() async throws {
        guard let userId = currentUser?.userId else { return }
        let path = String(format: AppConstants.profileImagePath, userId)
        try await storage.deleteImage(path: path)
        try await remote.updateProfileImageURL(userId: userId, url: nil)
    }

    // MARK: - Sign Out

    func signOut() {
        currentUserListenerTask?.cancel()
        currentUserListenerTask = nil
        currentUser = nil
        try? local.saveCurrentUser(user: nil)
    }

    // MARK: - Delete

    func deleteCurrentUser() async throws {
        guard let userId = currentUser?.userId else { return }
        let path = String(format: AppConstants.profileImagePath, userId)
        try? await storage.deleteImage(path: path)
        try await remote.deleteUser(userId: userId)
        signOut()
    }

    // MARK: - Local Preferences

    func lastSelectedTab() -> Int {
        UserDefaults.standard.object(forKey: lastTabKey) as? Int ?? 0
    }

    func saveLastSelectedTab(_ tabIndex: Int) {
        UserDefaults.standard.set(tabIndex, forKey: lastTabKey)
    }
}
