//
//  StreakHeatmapConfig.swift
//  TapZero
//

import Foundation

extension HistoryScreen.StreakHeatmapEntity {
    struct Config: Equatable {
        let days: [HeatmapDay]
        let currentStreak: Int
        let maxGamesInDay: Int
    }

    struct HeatmapDay: Equatable, Identifiable {
        let id: String
        let dayLabel: String
        let gamesPlayed: Int
    }
}
