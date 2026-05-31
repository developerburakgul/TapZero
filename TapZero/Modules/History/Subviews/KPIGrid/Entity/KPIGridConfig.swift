//
//  KPIGridConfig.swift
//  TapZero
//

import Foundation

extension HistoryScreen.KPIGridEntity {
    struct Config: Equatable {
        let bestRoundScore: Int
        let bestRoundDate: String
        let bestStreak: Int
        let perfectCount: Int
        let totalGames: Int
        let perfectPercentage: Double
        let avgOffBy: String
    }
}
