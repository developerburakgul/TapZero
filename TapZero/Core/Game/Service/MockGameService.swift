//
//  MockGameService.swift
//  TapZero
//

import Foundation

@MainActor
class MockGameService: GameServiceProtocol {
    var mockStats: UserStatsModel?
    var mockGameHistory: [GameModel]
    var mockGlobalLeaderboard: [GlobalLeaderboardEntry]
    var mockDailyLeaderboard: [DailyLeaderboardEntry]

    init(
        stats: UserStatsModel? = .mock,
        gameHistory: [GameModel] = GameModel.mocks,
        globalLeaderboard: [GlobalLeaderboardEntry] = GlobalLeaderboardEntry.mocks,
        dailyLeaderboard: [DailyLeaderboardEntry] = DailyLeaderboardEntry.mocks
    ) {
        self.mockStats = stats
        self.mockGameHistory = gameHistory
        self.mockGlobalLeaderboard = globalLeaderboard
        self.mockDailyLeaderboard = dailyLeaderboard
    }

    // MARK: - Cloud Functions

    func submitGame(targetSeconds: Int, tappedSeconds: Double, score: Int) async throws -> SubmitGameResponse {
        let game = GameModel(
            gameId: UUID().uuidString,
            targetSeconds: targetSeconds,
            tappedSeconds: tappedSeconds,
            score: score,
            playedAt: .now
        )
        mockGameHistory.insert(game, at: 0)

        return SubmitGameResponse(
            gameId: game.gameId,
            score: score,
            stats: SubmitGameResponse.StatsSnapshot(
                bestScore: max(mockStats?.bestScore ?? 0, score),
                totalGamesPlayed: (mockStats?.totalGamesPlayed ?? 0) + 1,
                top10Average: mockStats?.top10Average ?? score,
                globalRank: mockStats?.globalRank ?? 1,
                dailyBestScore: max(mockStats?.dailyBestScore ?? 0, score),
                dailyGamesPlayed: (mockStats?.dailyGamesPlayed ?? 0) + 1,
                dailyRank: mockStats?.dailyRank ?? 1
            )
        )
    }

    func deleteAccount() async throws {
        mockStats = nil
        mockGameHistory = []
        mockGlobalLeaderboard = []
        mockDailyLeaderboard = []
    }

    // MARK: - Firestore Reads

    func fetchGameHistory(userId: String, limit: Int) async throws -> [GameModel] {
        Array(mockGameHistory.prefix(limit))
    }

    func fetchUserStats(userId: String) async throws -> UserStatsModel? {
        mockStats
    }

    func fetchGlobalLeaderboard(limit: Int) async throws -> [GlobalLeaderboardEntry] {
        Array(mockGlobalLeaderboard.prefix(limit))
    }

    func fetchDailyLeaderboard(dateString: String, limit: Int) async throws -> [DailyLeaderboardEntry] {
        Array(mockDailyLeaderboard.prefix(limit))
    }
}
