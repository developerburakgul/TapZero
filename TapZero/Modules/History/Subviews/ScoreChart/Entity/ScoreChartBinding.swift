//
//  ScoreChartBinding.swift
//  TapZero
//

import Foundation

extension HistoryScreen.ScoreChartEntity {
    struct Binding: Equatable {
        var selectedGameId: Int?
        var scrollPosition: Int = 0
    }
}
