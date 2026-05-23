//
//  UserStatsModel.swift
//  TapZero
//

import Foundation

struct UserStatsModel: Codable, Sendable {
    let userId: String
    let bestScore: Int
    let totalGamesPlayed: Int
    let top10Average: Int
    let globalRank: Int
    let dailyBestScore: Int
    let dailyGamesPlayed: Int
    let dailyRank: Int
    let lastPlayedAt: Date?
    let updatedAt: Date?

    static var mock: Self {
        Self(
            userId: "mock_user_123",
            bestScore: 935,
            totalGamesPlayed: 42,
            top10Average: 887,
            globalRank: 12,
            dailyBestScore: 871,
            dailyGamesPlayed: 3,
            dailyRank: 5,
            lastPlayedAt: .now,
            updatedAt: .now
        )
    }
}
