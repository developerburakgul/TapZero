//
//  LeaderBoardViewModel+Service.swift
//  TapZero
//

import Foundation

// MARK: - Service
extension LeaderBoardViewModel {
    func fetchGlobalLeaderboard() async {
        await gameManager.fetchGlobalLeaderboard(limit: 50)
    }

    func fetchDailyLeaderboard() async {
        await gameManager.fetchDailyLeaderboard(limit: 50)
    }

    func fetchUserStats() async {
        guard let userId = currentUserId else { return }
        await gameManager.fetchUserStats(userId: userId)
    }
}
