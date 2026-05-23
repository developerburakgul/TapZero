//
//  GameServiceProtocol.swift
//  TapZero
//

import Foundation

@MainActor
protocol GameServiceProtocol: Sendable {
    // MARK: - Cloud Functions (Callable)

    func submitGame(targetSeconds: Int, tappedSeconds: Double, score: Int) async throws -> SubmitGameResponse
    func deleteAccount() async throws

    // MARK: - Firestore Reads

    func fetchGameHistory(userId: String, limit: Int) async throws -> [GameModel]
    func fetchUserStats(userId: String) async throws -> UserStatsModel?
    func fetchGlobalLeaderboard(limit: Int) async throws -> [GlobalLeaderboardEntry]
    func fetchDailyLeaderboard(dateString: String, limit: Int) async throws -> [DailyLeaderboardEntry]
}
