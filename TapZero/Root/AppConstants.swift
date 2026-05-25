//
//  AppConstants.swift
//  TapZero
//

import Foundation

enum AppConstants {
    // MARK: - App Store
    static let appStoreId = "id000000000"
    static var appStoreURL: URL { URL(string: "https://apps.apple.com/app/\(appStoreId)")! } // swiftlint:disable:this force_unwrapping
    static var writeReviewURL: URL { URL(string: "https://apps.apple.com/app/\(appStoreId)?action=write-review")! } // swiftlint:disable:this force_unwrapping

    // MARK: - Legal
    static let privacyPolicyURL = URL(string: "https://www.apple.com/legal/privacy")! // swiftlint:disable:this force_unwrapping
    static let termsOfServiceURL = URL(string: "https://www.apple.com/legal/internet-services/terms/site.html")! // swiftlint:disable:this force_unwrapping

    // MARK: - Keychain
    static let keychainService = "com.tapzero.keychain"

    // MARK: - UserDefaults
    static let hasLaunchedBeforeKey = "hasLaunchedBefore"

    // MARK: - Storage
    static let imageContentType = "image/jpeg"
    static let profileImagePath = "users/%@/profile.jpg"
    static let mockStorageBaseURL = "https://mock-storage.example.com/"
}
