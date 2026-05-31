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
            lhs.config == rhs.config
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

        private var chartContent: some View {
            Chart {
                ForEach(config.dataPoints) { point in
                    LineMark(
                        x: .value("Round", point.id),
                        y: .value("Score", point.score)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
                    .lineStyle(StrokeStyle(lineWidth: constants.lineWidth, lineCap: .round, lineJoin: .round))
                }

                ForEach(constants.gridlines, id: \.self) { value in
                    RuleMark(y: .value("Grid", value))
                        .foregroundStyle(TapZeroDesign.Hairline.default)
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [2, 3]))
                }

                RuleMark(y: .value("Grid", 0))
                    .foregroundStyle(TapZeroDesign.Hairline.default)
                    .lineStyle(StrokeStyle(lineWidth: 1))
            }
            .chartYScale(domain: constants.yAxisMin...constants.yAxisMax)
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 3)) { _ in
                    AxisGridLine()
                        .foregroundStyle(Color.clear)
                    AxisTick()
                        .foregroundStyle(Color.clear)
                    AxisValueLabel()
                        .foregroundStyle(TapZeroDesign.Foreground.tertiary)
                        .font(.system(size: 9, weight: .semibold))
                }
            }
            .chartYAxis {
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
            .frame(height: constants.chartHeight)
        }

        private func yAxisLabel(for value: Int) -> String {
            switch value {
            case 1000: "1k"
            case 0: "0"
            default: "\(value)"
            }
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
        binding: .constant(.init()),
        config: .init(dataPoints: points, isEmpty: false)
    )
    .background(TapZeroDesign.Background.primary)
}

#Preview("Chart — Empty") {
    HistoryScreen.ScoreChartView(
        binding: .constant(.init()),
        config: .init(dataPoints: [], isEmpty: true)
    )
    .background(TapZeroDesign.Background.primary)
}
