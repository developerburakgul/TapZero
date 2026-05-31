//
//  ScoreChartView.swift
//  TapZero
//

import Charts
import SwiftUI

extension HistoryScreen {
    struct ScoreChartView: View, Equatable {
        @Binding var binding: ScoreChartEntity.Binding
        let config: ScoreChartEntity.Config
        private let constants = Constants()

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config && lhs.binding == rhs.binding
        }

        var body: some View {
            if config.isEmpty {
                EmptyView()
            } else {
                chartContent
                    .padding(.horizontal, constants.horizontalPadding)
                    .padding(.top, constants.topPadding)
                    .padding(.bottom, constants.bottomPadding)
            }
        }
    }
}

// MARK: - Chart Content

extension HistoryScreen.ScoreChartView {
    private var chartContent: some View {
        Chart {
            scoreLine
            gridMarks
            averageLine
            selectedPointMarks
        }
        .chartYScale(domain: constants.yAxisMin...constants.yAxisMax)
        .chartXSelection(value: $binding.selectedGameId)
        .chartXAxis { xAxis }
        .chartYAxis { yAxis }
        .frame(height: constants.chartHeight)
    }
}

// MARK: - Score Line

extension HistoryScreen.ScoreChartView {
    private var scoreLine: some ChartContent {
        ForEach(config.dataPoints) { point in
            LineMark(
                x: .value("Round", point.id),
                y: .value("Score", point.score)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(TapZeroDesign.Foreground.primary)
            .lineStyle(StrokeStyle(lineWidth: constants.lineWidth, lineCap: .round, lineJoin: .round))
        }
    }
}

// MARK: - Grid Marks

extension HistoryScreen.ScoreChartView {
    private var gridMarks: some ChartContent {
        ForEach(constants.gridlines, id: \.self) { value in
            RuleMark(y: .value("Grid", value))
                .foregroundStyle(TapZeroDesign.Hairline.default)
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [2, 3]))
        }

        return RuleMark(y: .value("Grid", 0))
            .foregroundStyle(TapZeroDesign.Hairline.default)
            .lineStyle(StrokeStyle(lineWidth: 1))
    }
}

// MARK: - Average Line

extension HistoryScreen.ScoreChartView {
    private var averageLine: some ChartContent {
        RuleMark(y: .value("Average", config.averageScore))
            .foregroundStyle(TapZeroDesign.History.chartAverage)
            .lineStyle(StrokeStyle(lineWidth: 1, dash: constants.averageLineDash))
            .annotation(position: .leading, spacing: 2) {
                Text("\(config.averageScore)")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(TapZeroDesign.History.chartAverage)
                    .opacity(0.8)
            }
    }
}

// MARK: - Selected Point

extension HistoryScreen.ScoreChartView {
    @ChartContentBuilder
    private var selectedPointMarks: some ChartContent {
        if let selected = selectedPoint {
            RuleMark(x: .value("Selected", selected.id))
                .foregroundStyle(TapZeroDesign.Foreground.primary.opacity(constants.guideOpacity))
                .lineStyle(StrokeStyle(lineWidth: 0.8, dash: constants.guideDash))

            PointMark(
                x: .value("Round", selected.id),
                y: .value("Score", selected.score)
            )
            .symbol {
                markerSymbol
            }
            .annotation(position: .top, spacing: 6) {
                selectedPill(score: selected.score, gameNumber: selected.id)
            }
        }
    }

    private var markerSymbol: some View {
        ZStack {
            Circle()
                .fill(TapZeroDesign.Background.primary)
                .frame(width: constants.markerOuterSize, height: constants.markerOuterSize)
            Circle()
                .stroke(TapZeroDesign.Foreground.primary, lineWidth: constants.markerStrokeWidth)
                .frame(width: constants.markerOuterSize, height: constants.markerOuterSize)
            Circle()
                .fill(TapZeroDesign.Foreground.primary)
                .frame(width: constants.markerInnerSize, height: constants.markerInnerSize)
        }
    }

    private func selectedPill(score: Int, gameNumber: Int) -> some View {
        VStack(spacing: 1) {
            Text(TextKey.History.chartPillScore(score))
                .font(.system(size: constants.pillFontSize, weight: .bold))
                .foregroundStyle(TapZeroDesign.Button.primaryForeground)
            Text(TextKey.History.chartPillGame(gameNumber))
                .font(.system(size: constants.pillSubFontSize, weight: .medium))
                .foregroundStyle(TapZeroDesign.Button.primaryForeground.opacity(0.7))
        }
        .monospacedDigit()
        .padding(.horizontal, constants.pillHPadding)
        .padding(.vertical, constants.pillVPadding)
        .background(TapZeroDesign.Foreground.primary)
        .clipShape(RoundedRectangle(cornerRadius: constants.pillCornerRadius))
    }

    private var selectedPoint: HistoryScreen.ScoreChartEntity.ChartDataPoint? {
        guard let id = binding.selectedGameId else { return config.dataPoints.last }
        return config.dataPoints.first { $0.id == id }
    }
}

// MARK: - Axes

extension HistoryScreen.ScoreChartView {
    private var xAxis: some AxisContent {
        AxisMarks(values: xAxisValues) { value in
            AxisGridLine()
                .foregroundStyle(Color.clear)
            AxisTick()
                .foregroundStyle(Color.clear)
            AxisValueLabel {
                if let intValue = value.as(Int.self) {
                    Text("#\(intValue)")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(TapZeroDesign.Foreground.tertiary)
                }
            }
        }
    }

    private var yAxis: some AxisContent {
        AxisMarks(values: [0, 250, 500, 750, 1000]) { value in
            AxisGridLine()
                .foregroundStyle(Color.clear)
            AxisTick()
                .foregroundStyle(Color.clear)
            AxisValueLabel {
                if let intValue = value.as(Int.self) {
                    Text(yAxisLabel(for: intValue))
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(TapZeroDesign.Foreground.tertiary)
                }
            }
        }
    }

    private var xAxisValues: [Int] {
        guard let first = config.dataPoints.first?.id,
              let last = config.dataPoints.last?.id else { return [] }
        if config.dataPoints.count <= 2 { return [first, last] }
        let mid = (first + last) / 2
        return [first, mid, last]
    }

    private func yAxisLabel(for value: Int) -> String {
        switch value {
        case 1000: "1k"
        case 0: "0"
        default: "\(value)"
        }
    }
}

// MARK: - Previews

#Preview("Chart — Sample Data") {
    let points: [HistoryScreen.ScoreChartEntity.ChartDataPoint] = [
        .init(id: 1, score: 720, rating: .mid),
        .init(id: 2, score: 850, rating: .good),
        .init(id: 3, score: 910, rating: .good),
        .init(id: 4, score: 780, rating: .mid),
        .init(id: 5, score: 995, rating: .perfect),
        .init(id: 6, score: 640, rating: .bad),
        .init(id: 7, score: 870, rating: .good),
        .init(id: 8, score: 930, rating: .good),
        .init(id: 9, score: 960, rating: .good),
        .init(id: 10, score: 890, rating: .good)
    ]

    HistoryScreen.ScoreChartView(
        binding: .constant(.init(selectedGameId: 10)),
        config: .init(dataPoints: points, isEmpty: false, averageScore: 855)
    )
    .background(TapZeroDesign.Background.primary)
}

#Preview("Chart — Empty") {
    HistoryScreen.ScoreChartView(
        binding: .constant(.init()),
        config: .init(dataPoints: [], isEmpty: true, averageScore: 0)
    )
    .background(TapZeroDesign.Background.primary)
}
