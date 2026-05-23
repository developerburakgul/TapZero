//
//  UserAuthInfo.swift
//  TapZero
//

import SwiftUI

struct UserAuthInfo: Sendable, Codable {
    let uid: String
    let email: String?
    let isAnonymous: Bool
    let creationDate: Date?
    let lastSignInDate: Date?
    let providerIds: [String]

    init(
        uid: String,
        email: String? = nil,
        isAnonymous: Bool = false,
        creationDate: Date? = nil,
        lastSignInDate: Date? = nil,
        providerIds: [String] = []
    ) {
        self.uid = uid
        self.email = email
        self.isAnonymous = isAnonymous
        self.creationDate = creationDate
        self.lastSignInDate = lastSignInDate
        self.providerIds = providerIds
    }

    enum CodingKeys: String, CodingKey {
        case uid
        case email
        case isAnonymous = "is_anonymous"
        case creationDate = "creation_date"
        case lastSignInDate = "last_sign_in_date"
        case providerIds = "provider_ids"
    }

    var authProvider: AuthProvider {
        if providerIds.contains("apple.com") { return .apple }
        if providerIds.contains("google.com") { return .google }
        if providerIds.contains("password") { return .email }
        return .anonymous
    }

    enum AuthProvider: String, Sendable {
        case apple, google, email, anonymous
    }

    static func mock(isAnonymous: Bool = false) -> Self {
        Self(
            uid: "mock_user_123",
            email: "hello@mock.com",
            isAnonymous: isAnonymous,
            creationDate: .now,
            lastSignInDate: .now,
            providerIds: ["google.com"]
        )
    }

    var eventParameters: [String: Any] {
        let dict: [String: Any?] = [
            "uauth_\(CodingKeys.uid.rawValue)": uid,
            "uauth_\(CodingKeys.email.rawValue)": email,
            "uauth_\(CodingKeys.isAnonymous.rawValue)": isAnonymous,
            "uauth_\(CodingKeys.creationDate.rawValue)": creationDate,
            "uauth_\(CodingKeys.lastSignInDate.rawValue)": lastSignInDate
        ]
        return dict.compactMapValues { $0 }
    }
}
