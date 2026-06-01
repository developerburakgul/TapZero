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
                    .onAppear {
                        if config.dataPoints.count > constants.maxVisiblePoints {
                            binding.scrollPosition = config.dataPoints.count - constants.maxVisiblePoints + 1
                        }
                        guard binding.selectedGameId == nil else { return }
                        let best = config.dataPoints.max { $0.score < $1.score }
                        binding.selectedGameId = best?.id
                    }
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

    private var visibleDomainLength: Int {
        min(max(config.dataPoints.count, 1), constants.maxVisiblePoints)
    }

    private func chartBody(height: CGFloat) -> some View {
        Chart {
            scoreLine
            gridMarks
            averageLine
            selectedGuideMarks
        }
        .chartYScale(domain: constants.yAxisMin...constants.yAxisMax)
        .chartXAxis { xAxis }
        .chartYAxis { yAxis }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: visibleDomainLength)
        .chartScrollPosition(x: $binding.scrollPosition)
        .chartXSelection(value: $binding.selectedGameId)
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
        AxisMarks(position: .leading, values: yAxisValues) { value in
            AxisGridLine()
                .foregroundStyle(Color.clear)
            AxisTick()
                .foregroundStyle(Color.clear)
            AxisValueLabel {
                if let intValue = value.as(Int.self) {
                    if intValue == config.averageScore {
                        Text(TextKey.History.chartAvgLabel(intValue))
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(TapZeroDesign.History.chartAverage)
                    } else {
                        Text(verbatim: "\(intValue)")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundStyle(TapZeroDesign.Foreground.tertiary)
                    }
                }
            }
        }
    }

    private var yAxisValues: [Int] {
        let base = [0, 250, 500, 750, 1000]
        let avg = config.averageScore
        let filtered = base.filter { abs($0 - avg) > 50 }
        return (filtered + [avg]).sorted()
    }

    private var xAxisValues: [Int] {
        let ids = config.dataPoints.map(\.id)
        guard let first = ids.first, let last = ids.last else { return [] }
        if ids.count <= 5 { return ids }
        let step = max(1, (last - first) / 4)
        var values: [Int] = []
        var current = first
        while current <= last {
            if ids.contains(current) { values.append(current) }
            current += step
        }
        if values.last != last { values.append(last) }
        return values
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
        ScrollView {
            VStack(spacing: 0) {
                HistoryScreen.ScoreChartView(
                    binding: $binding,
                    config: config
                )

                ForEach(0..<10, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(TapZeroDesign.Foreground.primary.opacity(0.08))
                        .frame(height: 64)
                        .padding(.horizontal, 20)
                        .padding(.top, 6)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(TapZeroDesign.Background.primary.ignoresSafeArea())
    }
}

private let previewFewPoints: [HistoryScreen.ScoreChartEntity.ChartDataPoint] = [
    .init(id: 1, score: 720, rating: .mid),
    .init(id: 2, score: 850, rating: .good),
    .init(id: 3, score: 910, rating: .good),
    .init(id: 4, score: 780, rating: .mid),
    .init(id: 5, score: 995, rating: .perfect)
]

private let previewManyPoints: [HistoryScreen.ScoreChartEntity.ChartDataPoint] = [
    .init(id: 1, score: 720, rating: .mid),
    .init(id: 2, score: 850, rating: .good),
    .init(id: 3, score: 910, rating: .good),
    .init(id: 4, score: 780, rating: .mid),
    .init(id: 5, score: 995, rating: .perfect),
    .init(id: 6, score: 640, rating: .bad),
    .init(id: 7, score: 870, rating: .good),
    .init(id: 8, score: 930, rating: .good),
    .init(id: 9, score: 960, rating: .good),
    .init(id: 10, score: 890, rating: .good),
    .init(id: 11, score: 750, rating: .mid),
    .init(id: 12, score: 820, rating: .good),
    .init(id: 13, score: 940, rating: .good),
    .init(id: 14, score: 680, rating: .mid),
    .init(id: 15, score: 910, rating: .good),
    .init(id: 16, score: 970, rating: .perfect),
    .init(id: 17, score: 830, rating: .good),
    .init(id: 18, score: 760, rating: .mid),
    .init(id: 19, score: 900, rating: .good),
    .init(id: 20, score: 950, rating: .perfect)
]

#Preview("Chart — 5 Points") {
    ScoreChartPreview(
        config: .init(dataPoints: previewFewPoints, isEmpty: false, averageScore: 851)
    )
}

#Preview("Chart — 20 Points") {
    ScoreChartPreview(
        config: .init(dataPoints: previewManyPoints, isEmpty: false, averageScore: 860)
    )
}

#Preview("Chart — Empty") {
    ScoreChartPreview(
        config: .init(dataPoints: [], isEmpty: true, averageScore: 0)
    )
}
