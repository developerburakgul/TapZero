//
//  TabbarViewModel+Service.swift
//  Created by __Username__ on __Date__
//

import Foundation

// MARK: - Service
extension TabbarViewModel {
    func fetchData() async {
        guard let userId = userManager.currentUser?.userId else { return }
        await gameManager.fetchUserStats(userId: userId)
    }
}
