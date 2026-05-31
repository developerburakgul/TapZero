//
//  ScoreChartConfig.swift
//  TapZero
//

import Foundation

extension HistoryScreen.ScoreChartEntity {
    struct Config: Equatable {
        let dataPoints: [ChartDataPoint]
        let isEmpty: Bool
        let averageScore: Int
    }

    struct ChartDataPoint: Equatable, Identifiable {
        let id: Int
        let score: Int
        let rating: PerformanceRating
    }
}
