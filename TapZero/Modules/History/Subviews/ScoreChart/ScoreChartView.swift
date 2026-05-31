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

        private var chartHeight: CGFloat {
            let screen = UIScreen.main.bounds.height
            let computed = screen * constants.chartHeightRatio
            return min(constants.chartMaxHeight, max(constants.chartMinHeight, computed))
        }

        var body: some View {
            if config.isEmpty {
                emptyChart(height: chartHeight)
                    .padding(.horizontal, constants.horizontalPadding)
                    .padding(.top, constants.topPadding)
                    .padding(.bottom, constants.bottomPadding)
            } else {
                chartContent(height: chartHeight)
                    .padding(.horizontal, constants.horizontalPadding)
                    .padding(.top, constants.topPadding)
                    .padding(.bottom, constants.bottomPadding)
            }
        }
    }
}

// MARK: - Chart Content

extension HistoryScreen.ScoreChartView {
    private func chartContent(height: CGFloat) -> some View {
        VStack(spacing: 0) {
            selectedPillOverlay
            chartBody(height: height)
        }
    }

    private var selectedPillOverlay: some View {
        ZStack {
            if let selected = selectedPoint {
                selectedPill(score: selected.score, gameNumber: selected.id)
                    .transition(.opacity)
            }
        }
        .frame(height: constants.pillAreaHeight)
        .animation(.easeInOut(duration: 0.15), value: binding.selectedGameId)
    }

    private func chartBody(height: CGFloat) -> some View {
        Chart {
            scoreLine
            gridMarks
            averageLine
            selectedGuideMarks
        }
        .chartYScale(domain: constants.yAxisMin...constants.yAxisMax)
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: min(config.dataPoints.count, constants.maxVisiblePoints))
        .chartXAxis { xAxis }
        .chartYAxis { yAxis }
        .chartOverlay { proxy in
            GeometryReader { geo in
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .onTapGesture { location in
                        guard let plotFrame = proxy.plotFrame else { return }
                        let x = location.x - geo[plotFrame].origin.x
                        if let gameId: Int = proxy.value(atX: x) {
                            let nearest = config.dataPoints
                                .min { abs($0.id - gameId) < abs($1.id - gameId) }
                            if binding.selectedGameId == nearest?.id {
                                binding.selectedGameId = nil
                            } else {
                                binding.selectedGameId = nearest?.id
                            }
                        }
                    }
            }
        }
        .frame(height: height)
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
    @ChartContentBuilder
    private var gridMarks: some ChartContent {
        ForEach(constants.gridlines, id: \.self) { value in
            RuleMark(y: .value("Grid", value))
                .foregroundStyle(TapZeroDesign.Hairline.default)
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [2, 3]))
        }

        RuleMark(y: .value("Grid", 0))
            .foregroundStyle(TapZeroDesign.Hairline.default)
            .lineStyle(StrokeStyle(lineWidth: 1))
    }
}

// MARK: - Average Line

extension HistoryScreen.ScoreChartView {
    private var averageLine: some ChartContent {
        RuleMark(y: .value("Average", config.averageScore))
            .foregroundStyle(TapZeroDesign.History.chartAverage.opacity(0.55))
            .lineStyle(StrokeStyle(lineWidth: 1, dash: constants.averageLineDash))
            .annotation(position: .leading, spacing: 2) {
                Text(verbatim: "\(config.averageScore)")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(TapZeroDesign.History.chartAverage)
                    .opacity(0.8)
            }
    }
}

// MARK: - Selected Point

extension HistoryScreen.ScoreChartView {
    @ChartContentBuilder
    private var selectedGuideMarks: some ChartContent {
        if let selected = selectedPoint {
            // Vertical guide
            RuleMark(x: .value("Selected", selected.id))
                .foregroundStyle(TapZeroDesign.Foreground.primary.opacity(constants.guideOpacity))
                .lineStyle(StrokeStyle(lineWidth: 0.8, dash: constants.guideDash))
                .annotation(position: .bottom, spacing: 2) {
                    Text(TextKey.History.chartGameNumber(selected.id))
                        .font(.system(size: 9, weight: .bold))
                        .monospacedDigit()
                        .foregroundStyle(TapZeroDesign.Foreground.primary)
                }

            // Horizontal guide (y-axis → point)
            RuleMark(
                xStart: .value("Start", config.dataPoints.first?.id ?? selected.id),
                xEnd: .value("End", selected.id),
                y: .value("Score", selected.score)
            )
            .foregroundStyle(TapZeroDesign.Foreground.primary.opacity(0.20))
            .lineStyle(StrokeStyle(lineWidth: 0.8, dash: constants.guideDash))

            // Marker ring
            PointMark(
                x: .value("Round", selected.id),
                y: .value("Score", selected.score)
            )
            .symbol {
                markerSymbol
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
        guard let id = binding.selectedGameId else { return nil }
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
                    Text(verbatim: "#\(intValue)")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(TapZeroDesign.Foreground.tertiary)
                }
            }
        }
    }

    private var yAxis: some AxisContent {
        AxisMarks(position: .leading, values: [0, 250, 500, 750, 1000]) { value in
            AxisGridLine()
                .foregroundStyle(Color.clear)
            AxisTick()
                .foregroundStyle(Color.clear)
            AxisValueLabel {
                if let intValue = value.as(Int.self) {
                    Text(verbatim: "\(intValue)")
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
}

// MARK: - Empty State

private struct EmptyChartView: View {
    let height: CGFloat
    private let constants = HistoryScreen.ScoreChartView.Constants()
    @State private var appeared = false

    private let placeholderPoints: [HistoryScreen.ScoreChartEntity.ChartDataPoint] = [
        .init(id: 1, score: 420, rating: .mid),
        .init(id: 2, score: 580, rating: .good),
        .init(id: 3, score: 510, rating: .mid),
        .init(id: 4, score: 700, rating: .good),
        .init(id: 5, score: 650, rating: .good),
        .init(id: 6, score: 780, rating: .good),
        .init(id: 7, score: 720, rating: .good),
        .init(id: 8, score: 850, rating: .good),
        .init(id: 9, score: 810, rating: .good),
        .init(id: 10, score: 900, rating: .perfect)
    ]

    var body: some View {
        Chart {
            ForEach(placeholderPoints) { point in
                LineMark(
                    x: .value("Round", point.id),
                    y: .value("Score", appeared ? point.score : 500)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(TapZeroDesign.Foreground.primary)
                .lineStyle(StrokeStyle(
                    lineWidth: constants.lineWidth,
                    lineCap: .round,
                    lineJoin: .round
                ))
            }
        }
        .chartYScale(domain: constants.yAxisMin...constants.yAxisMax)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .frame(height: height)
        .opacity(constants.emptyOpacity)
        .allowsHitTesting(false)
        .onAppear {
            withAnimation(.easeOut(duration: constants.emptyAnimationDuration)) {
                appeared = true
            }
        }
    }
}

extension HistoryScreen.ScoreChartView {
    func emptyChart(height: CGFloat) -> some View {
        EmptyChartView(height: height)
    }
}

// MARK: - Previews

private struct ScoreChartPreview: View {
    @State private var binding: HistoryScreen.ScoreChartEntity.Binding = .init()

    let config: HistoryScreen.ScoreChartEntity.Config

    var body: some View {
        VStack {
            Spacer()
            HistoryScreen.ScoreChartView(
                binding: $binding,
                config: config
            )
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(TapZeroDesign.Background.primary.ignoresSafeArea())
    }
}

private let previewPoints: [HistoryScreen.ScoreChartEntity.ChartDataPoint] = [
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

#Preview("Chart — Interactive") {
    ScoreChartPreview(
        config: .init(dataPoints: previewPoints, isEmpty: false, averageScore: 855)
    )
}

#Preview("Chart — Empty") {
    ScoreChartPreview(
        config: .init(dataPoints: [], isEmpty: true, averageScore: 0)
    )
}
