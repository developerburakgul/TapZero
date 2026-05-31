//
//  ScoreChartConstants.swift
//  TapZero
//

import SwiftUI

extension HistoryScreen.ScoreChartView {
    struct Constants {
        let chartHeight: CGFloat = 132
        let horizontalPadding: CGFloat = 20
        let topPadding: CGFloat = 4
        let bottomPadding: CGFloat = 8
        let lineWidth: CGFloat = 1.8
        let ringOuterRadius: CGFloat = 6
        let ringStrokeWidth: CGFloat = 1.8
        let ringInnerRadius: CGFloat = 2.2
        let pillWidth: CGFloat = 72
        let pillCornerRadius: CGFloat = 8
        let pillVerticalPadding: CGFloat = 4
        let gridlines: [Int] = [250, 500, 750]
        let yAxisMin: Int = 0
        let yAxisMax: Int = 1000
    }
}
