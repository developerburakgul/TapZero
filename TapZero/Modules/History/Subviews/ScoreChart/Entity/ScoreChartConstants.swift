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
        let gridlines: [Int] = [250, 500, 750]
        let yAxisMin: Int = 0
        let yAxisMax: Int = 1000

        // Average line
        let averageLineDash: [CGFloat] = [4, 3]

        // Selected point marker
        let markerOuterSize: CGFloat = 12
        let markerStrokeWidth: CGFloat = 1.8
        let markerInnerSize: CGFloat = 4.4
        let guideDash: [CGFloat] = [2, 2]
        let guideOpacity: Double = 0.30

        // Floating pill
        let pillFontSize: CGFloat = 11
        let pillSubFontSize: CGFloat = 9
        let pillHPadding: CGFloat = 10
        let pillVPadding: CGFloat = 4
        let pillCornerRadius: CGFloat = 8
    }
}
