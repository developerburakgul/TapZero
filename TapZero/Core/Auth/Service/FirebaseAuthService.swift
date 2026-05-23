//
//  FirebaseAuthService.swift
//  TapZero
//

@preconcurrency import FirebaseAuth
import GoogleSignIn
import SignInAppleAsync
import SwiftUI

@MainActor
struct FirebaseAuthService: AuthServiceProtocol {
    // swiftlint:disable:next line_length
    func addAuthenticatedUserListener(onListenerAttached: (any NSObjectProtocol) -> Void) -> AsyncStream<UserAuthInfo?> {
        AsyncStream { continuation in
            let listener = Auth.auth().addStateDidChangeListener { _, currentUser in
                if let currentUser {
                    let user = UserAuthInfo(user: currentUser)
                    continuation.yield(user)
                } else {
                    continuation.yield(nil)
                }
            }

            onListenerAttached(listener)
        }
    }

    func removeAuthenticatedUserListener(listener: any NSObjectProtocol) {
        Auth.auth().removeStateDidChangeListener(listener)
    }

    func getAuthenticatedUser() -> UserAuthInfo? {
        if let user = Auth.auth().currentUser {
            return UserAuthInfo(user: user)
        }
        return nil
    }

    func signInAnonymously() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        let result = try await Auth.auth().signInAnonymously()
        return result.asAuthInfo
    }

    // MARK: - Apple

    func signInApple() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        let helper = SignInWithAppleHelper()
        let response = try await helper.signIn()

        let credential = OAuthProvider.credential(
            providerID: AuthProviderID.apple,
            idToken: response.token,
            rawNonce: response.nonce
        )

        return try await linkOrSignIn(with: credential)
    }

    // MARK: - Google

    func signInGoogle() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        guard let topVC = topViewController() else {
            throw AuthError.noViewController
        }

        let gidResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        guard let idToken = gidResult.user.idToken?.tokenString else {
            throw AuthError.missingToken
        }

        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: gidResult.user.accessToken.tokenString
        )

        return try await linkOrSignIn(with: credential)
    }

    // MARK: - Link or Sign In

    private func linkOrSignIn(with credential: AuthCredential) async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        if let user = Auth.auth().currentUser, user.isAnonymous {
            do {
                let result = try await user.link(with: credential)
                return result.asAuthInfo
            } catch let error as NSError {
                let authError = AuthErrorCode(rawValue: error.code)
                switch authError {
                case .providerAlreadyLinked, .credentialAlreadyInUse:
                    if let secondary = error
                        .userInfo["FIRAuthErrorUserInfoUpdatedCredentialKey"] as? AuthCredential {
                        let result = try await Auth.auth().signIn(with: secondary)
                        return result.asAuthInfo
                    }
                default:
                    break
                }
            }
        }

        let result = try await Auth.auth().signIn(with: credential)
        return result.asAuthInfo
    }

    // MARK: - Email

    func signInEmail(email: String, password: String) async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.asAuthInfo
    }

    func createAccountEmail(email: String, password: String) async throws -> (user: UserAuthInfo, isNewUser: Bool) {
        if let user = Auth.auth().currentUser, user.isAnonymous {
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            let result = try await user.link(with: credential)
            return result.asAuthInfo
        }

        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return result.asAuthInfo
    }

    // MARK: - Sign Out / Delete

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }

        do {
            try await user.delete()
        } catch let error as NSError {
            let authError = AuthErrorCode(rawValue: error.code)
            switch authError {
            case .requiresRecentLogin:
                try await reauthenticateUser(error: error)
                return try await user.delete()
            default:
                throw error
            }
        }
    }

    private func reauthenticateUser(error: Error) async throws {
        guard let user = Auth.auth().currentUser,
              let providerId = user.providerData.first?.providerID else {
            throw AuthError.userNotFound
        }

        switch providerId {
        case "apple.com":
            let result = try await signInApple()
            guard user.uid == result.user.uid else {
                throw AuthError.reauthAccountChanged
            }
        case "google.com":
            let result = try await signInGoogle()
            guard user.uid == result.user.uid else {
                throw AuthError.reauthAccountChanged
            }
        default:
            throw error
        }
    }

    // MARK: - Helpers

    private func topViewController() -> UIViewController? {
        let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first
        return scene?.windows.first(where: \.isKeyWindow)?.rootViewController
    }

    // MARK: - Errors

    enum AuthError: LocalizedError {
        case userNotFound
        case reauthAccountChanged
        case noViewController
        case missingToken

        var errorDescription: String? {
            switch self {
            case .userNotFound:
                "Current authenticated user not found."
            case .reauthAccountChanged:
                "Reauthenticated switched accounts. Please check your account."
            case .noViewController:
                "Unable to find top view controller for sign in."
            case .missingToken:
                "Authentication token is missing."
            }
        }
    }
}

extension AuthDataResult {
    var asAuthInfo: (user: UserAuthInfo, isNewUser: Bool) {
        let user = UserAuthInfo(user: user)
        let isNewUser = additionalUserInfo?.isNewUser ?? true
        return (user, isNewUser)
    }
}
