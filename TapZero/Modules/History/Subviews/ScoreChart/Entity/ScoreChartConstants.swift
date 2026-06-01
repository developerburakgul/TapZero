//
//  ScoreChartConstants.swift
//  TapZero
//

import SwiftUI

extension HistoryScreen.ScoreChartView {
    struct Constants {
        let chartHeightRatio: CGFloat = 0.22
        let chartMinHeight: CGFloat = 132
        let chartMaxHeight: CGFloat = 240
        let horizontalPadding: CGFloat = 12
        let topPadding: CGFloat = 12
        let bottomPadding: CGFloat = 14
        let lineWidth: CGFloat = 1.8
        let gridlines: [Int] = [250, 500, 750]
        let yAxisMin: Int = 0
        let yAxisMax: Int = 1040
        let maxVisiblePoints: Int = 10

        // Average line
        let averageLineDash: [CGFloat] = [4, 3]

        // Selected point marker
        let markerOuterSize: CGFloat = 12
        let markerStrokeWidth: CGFloat = 1.8
        let markerInnerSize: CGFloat = 4.4
        let guideDash: [CGFloat] = [2, 2]
        let guideOpacity: Double = 0.30

        // Floating pill (above chart)
        let pillAreaHeight: CGFloat = 52
        let pillFontSize: CGFloat = 11
        let pillSubFontSize: CGFloat = 9
        let pillHPadding: CGFloat = 10
        let pillVPadding: CGFloat = 4
        let pillCornerRadius: CGFloat = 8

        // Empty state
        let emptyOpacity: Double = 0.15
        let emptyAnimationDuration: Double = 2.5
    }
}
