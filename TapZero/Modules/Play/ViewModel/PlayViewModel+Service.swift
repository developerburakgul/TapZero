//
//  PlayViewModel+Service.swift
//  TapZero
//

import Foundation

// MARK: - Service
extension PlayViewModel {
    func fetchData() async {
        guard let userId = userManager.currentUser?.userId else { return }
        await gameManager.fetchUserStats(userId: userId)
    }
}
