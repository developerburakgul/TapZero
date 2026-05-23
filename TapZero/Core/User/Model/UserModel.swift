//
//  UserModel.swift
//  TapZero
//

import SwiftUI

struct UserModel: Codable, Sendable {
    let userId: String
    let email: String?
    let displayName: String
    let isAnonymous: Bool
    let creationDate: Date?
    let creationVersion: String?
    let lastSignInDate: Date?
    let didCompleteOnboarding: Bool
    let profileColorHex: String?
    let profileImageURL: String?
    let updatedAt: Date?

    init(
        userId: String,
        email: String? = nil,
        displayName: String = "",
        isAnonymous: Bool = false,
        creationDate: Date? = nil,
        creationVersion: String? = nil,
        lastSignInDate: Date? = nil,
        didCompleteOnboarding: Bool = false,
        profileColorHex: String? = nil,
        profileImageURL: String? = nil,
        updatedAt: Date? = nil
    ) {
        self.userId = userId
        self.email = email
        self.displayName = displayName
        self.isAnonymous = isAnonymous
        self.creationDate = creationDate
        self.creationVersion = creationVersion
        self.lastSignInDate = lastSignInDate
        self.didCompleteOnboarding = didCompleteOnboarding
        self.profileColorHex = profileColorHex
        self.profileImageURL = profileImageURL
        self.updatedAt = updatedAt
    }

    init(auth: UserAuthInfo, creationVersion: String? = nil, displayName: String = "") {
        self.userId = auth.uid
        self.email = auth.email
        self.displayName = displayName
        self.isAnonymous = auth.isAnonymous
        self.creationDate = auth.creationDate
        self.creationVersion = creationVersion
        self.lastSignInDate = auth.lastSignInDate
        self.didCompleteOnboarding = false
        self.profileColorHex = nil
        self.profileImageURL = nil
        self.updatedAt = nil
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(String.self, forKey: .userId)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        displayName = try container.decodeIfPresent(String.self, forKey: .displayName) ?? ""
        isAnonymous = try container.decode(Bool.self, forKey: .isAnonymous)
        creationDate = try container.decodeIfPresent(Date.self, forKey: .creationDate)
        creationVersion = try container.decodeIfPresent(String.self, forKey: .creationVersion)
        lastSignInDate = try container.decodeIfPresent(Date.self, forKey: .lastSignInDate)
        didCompleteOnboarding = try container.decode(Bool.self, forKey: .didCompleteOnboarding)
        profileColorHex = try container.decodeIfPresent(String.self, forKey: .profileColorHex)
        profileImageURL = try container.decodeIfPresent(String.self, forKey: .profileImageURL)
        updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
    }

    enum CodingKeys: String, CodingKey {
        case userId
        case email
        case displayName = "name"
        case isAnonymous
        case creationDate = "createdAt"
        case creationVersion
        case lastSignInDate
        case didCompleteOnboarding = "onboardingDone"
        case profileColorHex
        case profileImageURL = "avatar"
        case updatedAt
    }

    @MainActor var profileColorCalculated: Color {
        if let profileColorHex {
            return Color(hex: profileColorHex)
        }
        return TapZeroDesign.Accent.primary
    }

    var eventParameters: [String: Any] {
        let dict: [String: Any?] = [
            "user_\(CodingKeys.userId.rawValue)": userId,
            "user_\(CodingKeys.email.rawValue)": email,
            "user_\(CodingKeys.isAnonymous.rawValue)": isAnonymous,
            "user_\(CodingKeys.creationDate.rawValue)": creationDate,
            "user_\(CodingKeys.creationVersion.rawValue)": creationVersion,
            "user_\(CodingKeys.lastSignInDate.rawValue)": lastSignInDate,
            "user_\(CodingKeys.didCompleteOnboarding.rawValue)": didCompleteOnboarding,
            "user_\(CodingKeys.profileColorHex.rawValue)": profileColorHex,
            "user_\(CodingKeys.profileImageURL.rawValue)": profileImageURL
        ]
        return dict.compactMapValues { $0 }
    }

    static var mock: Self {
        Self(
            userId: "mock_user_123",
            email: "hello@mock.com",
            displayName: "Burak",
            isAnonymous: false,
            creationDate: .now,
            creationVersion: "1.0",
            lastSignInDate: .now,
            didCompleteOnboarding: true,
            profileColorHex: "#007AFF"
        )
    }

    static var mocks: [Self] {
        [
            Self(
                userId: "user_1",
                email: "user1@mock.com",
                displayName: "Ali",
                creationDate: .now,
                didCompleteOnboarding: true,
                profileColorHex: "#007AFF"
            ),
            Self(
                userId: "user_2",
                email: "user2@mock.com",
                isAnonymous: true,
                creationDate: .now
            ),
            Self(
                userId: "user_3",
                email: "user3@mock.com",
                displayName: "Zeynep",
                creationDate: .now,
                didCompleteOnboarding: true,
                profileColorHex: "#5856D6"
            )
        ]
    }
}

// MARK: - Color Hex Support

extension Color {
    nonisolated init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let red, green, blue: UInt64
        switch hex.count {
        case 6:
            (red, green, blue) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (red, green, blue) = (0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: 1
        )
    }
}
