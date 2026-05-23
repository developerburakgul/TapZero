//
//  GameManager.swift
//  TapZero
//

import Foundation

@MainActor
final class GameManager: ObservableObject {
    private let service: GameServiceProtocol
    @Injected private var crashReporter: CrashReporterProtocol

    @Published private(set) var userStats: UserStatsModel?
    @Published private(set) var gameHistory: [GameModel] = []
    @Published private(set) var globalLeaderboard: [GlobalLeaderboardEntry] = []
    @Published private(set) var dailyLeaderboard: [DailyLeaderboardEntry] = []

    init(service: GameServiceProtocol) {
        self.service = service
    }

    // MARK: - Cloud Functions

    func submitGame(targetSeconds: Int, tappedSeconds: Double, score: Int) async throws -> SubmitGameResponse {
        do {
            let response = try await service.submitGame(
                targetSeconds: targetSeconds,
                tappedSeconds: tappedSeconds,
                score: score
            )
            updateStatsFromResponse(response)
            return response
        } catch {
            crashReporter.record(error: error)
            throw error
        }
    }

    func deleteAccount() async throws {
        do {
            try await service.deleteAccount()
            reset()
        } catch {
            crashReporter.record(error: error)
            throw error
        }
    }

    // MARK: - Data Fetching

    func fetchUserStats(userId: String) async {
        do {
            userStats = try await service.fetchUserStats(userId: userId)
        } catch {
            crashReporter.record(error: error)
        }
    }

    func fetchGameHistory(userId: String, limit: Int = 20) async {
        do {
            gameHistory = try await service.fetchGameHistory(userId: userId, limit: limit)
        } catch {
            crashReporter.record(error: error)
        }
    }

    func fetchGlobalLeaderboard(limit: Int = 50) async {
        do {
            globalLeaderboard = try await service.fetchGlobalLeaderboard(limit: limit)
        } catch {
            crashReporter.record(error: error)
        }
    }

    func fetchDailyLeaderboard(limit: Int = 50) async {
        do {
            let dateString = Self.todayDateString()
            dailyLeaderboard = try await service.fetchDailyLeaderboard(dateString: dateString, limit: limit)
        } catch {
            crashReporter.record(error: error)
        }
    }

    // MARK: - Cleanup

    func reset() {
        userStats = nil
        gameHistory = []
        globalLeaderboard = []
        dailyLeaderboard = []
    }

    // MARK: - Private

    private func updateStatsFromResponse(_ response: SubmitGameResponse) {
        let snapshot = response.stats
        userStats = UserStatsModel(
            userId: userStats?.userId ?? "",
            bestScore: snapshot.bestScore,
            totalGamesPlayed: snapshot.totalGamesPlayed,
            top10Average: snapshot.top10Average,
            globalRank: snapshot.globalRank,
            dailyBestScore: snapshot.dailyBestScore,
            dailyGamesPlayed: snapshot.dailyGamesPlayed,
            dailyRank: snapshot.dailyRank,
            lastPlayedAt: .now,
            updatedAt: .now
        )
    }

    static func todayDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: Date())
    }
}
