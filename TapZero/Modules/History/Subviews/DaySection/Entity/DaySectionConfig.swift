//
//  DaySectionConfig.swift
//  TapZero
//

import Foundation

extension HistoryScreen.DaySectionEntity {
    struct Config: Equatable, Identifiable {
        let id: String
        let dateLabel: String
        let gameCount: Int
        let rows: [HistoryScreen.ScoreRowEntity.Config]
    }
}
