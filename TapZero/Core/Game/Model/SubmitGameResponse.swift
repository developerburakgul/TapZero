//
//  SubmitGameResponse.swift
//  TapZero
//

import Foundation

struct SubmitGameResponse: Sendable {
    let gameId: String
    let score: Int
    let stats: StatsSnapshot

    struct StatsSnapshot: Sendable {
        let bestScore: Int
        let totalGamesPlayed: Int
        let top10Average: Int
        let globalRank: Int?
        let dailyBestScore: Int
        let dailyGamesPlayed: Int
        let dailyRank: Int?
    }

    init(gameId: String, score: Int, stats: StatsSnapshot) {
        self.gameId = gameId
        self.score = score
        self.stats = stats
    }

    init(data: [String: Any]) throws {
        guard
            let gameId = data["gameId"] as? String,
            let score = data["score"] as? Int,
            let statsDict = data["stats"] as? [String: Any]
        else {
            throw SubmitGameError.invalidResponse
        }

        guard
            let bestScore = statsDict["bestScore"] as? Int,
            let totalGamesPlayed = statsDict["totalGamesPlayed"] as? Int,
            let top10Average = statsDict["top10Average"] as? Int,
            let dailyBestScore = statsDict["dailyBestScore"] as? Int,
            let dailyGamesPlayed = statsDict["dailyGamesPlayed"] as? Int
        else {
            throw SubmitGameError.invalidStatsData
        }

        let globalRank = statsDict["globalRank"] as? Int
        let dailyRank = statsDict["dailyRank"] as? Int

        self.gameId = gameId
        self.score = score
        self.stats = StatsSnapshot(
            bestScore: bestScore,
            totalGamesPlayed: totalGamesPlayed,
            top10Average: top10Average,
            globalRank: globalRank,
            dailyBestScore: dailyBestScore,
            dailyGamesPlayed: dailyGamesPlayed,
            dailyRank: dailyRank
        )
    }

    static var mock: Self {
        Self(
            gameId: "mock_game_1",
            score: 871,
            stats: StatsSnapshot(
                bestScore: 935,
                totalGamesPlayed: 42,
                top10Average: 887,
                globalRank: 12,
                dailyBestScore: 871,
                dailyGamesPlayed: 3,
                dailyRank: 5
            )
        )
    }
}

enum SubmitGameError: LocalizedError {
    case invalidResponse
    case invalidStatsData

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server."
        case .invalidStatsData:
            return "Invalid stats data in response."
        }
    }
}
