//
//  HistoryViewModel+Service.swift
//  TapZero
//

import Foundation

// MARK: - Service
extension HistoryViewModel {
    func fetchGameHistory() async {
        guard let userId = currentUserId else { return }
        await gameManager.fetchGameHistory(userId: userId, limit: 50)
    }

    func fetchUserStats() async {
        guard let userId = currentUserId else { return }
        await gameManager.fetchUserStats(userId: userId)
    }
}
