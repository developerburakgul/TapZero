//
//  ScoreRowConfig.swift
//  TapZero
//

import SwiftUI

extension HistoryScreen.ScoreRowEntity {
    struct Config: Equatable, Identifiable {
        let id: String
        let score: Int
        let targetSeconds: Int
        let tappedSeconds: Double
        let delta: Double
        let rating: PerformanceRating
        let discColor: Color
        let discSoftBackground: Color
        let dateFormatted: String
        let subtitleFormatted: String
    }
}
