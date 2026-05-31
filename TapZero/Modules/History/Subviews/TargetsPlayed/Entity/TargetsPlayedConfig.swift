//
//  TargetsPlayedConfig.swift
//  TapZero
//

import Foundation

extension HistoryScreen.TargetsPlayedEntity {
    struct Config: Equatable {
        let targets: [TargetStat]
    }

    struct TargetStat: Equatable, Identifiable {
        let id: Int
        let targetLabel: String
        let playCount: Int
        let bestScore: Int
        let barFraction: Double
    }
}
