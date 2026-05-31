//
//  HeroStatConfig.swift
//  TapZero
//

import Foundation

extension HistoryScreen.HeroStatEntity {
    struct Config: Equatable {
        let averageScore: Int
        let totalGames: Int
        let trendPercentage: Double?
        let trendIsPositive: Bool
    }
}
