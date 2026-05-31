//
//  DistributionView.swift
//  TapZero
//

import SwiftUI

extension HistoryScreen {
    struct DistributionView: View, Equatable {
        @Binding var binding: DistributionEntity.Binding
        let config: DistributionEntity.Config
        private let constants = Constants()

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config && lhs.binding == rhs.binding
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                headerRow
                stackedBar
                legend
            }
            .padding(.horizontal, constants.sectionPadding)
            .padding(.vertical, constants.sectionPaddingVertical)
            .background(TapZeroDesign.Background.card)
            .clipShape(RoundedRectangle(cornerRadius: constants.sectionCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: constants.sectionCornerRadius)
                    .stroke(TapZeroDesign.Hairline.default, lineWidth: 0.5)
            )
        }

        // MARK: - Header

        private var headerRow: some View {
            HStack(alignment: .firstTextBaseline) {
                Text(TextKey.History.statDistribution)
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1.2)
                    .textCase(.uppercase)
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)
                Spacer()
                Text(TextKey.History.distributionByAccuracy)
                    .font(.system(size: 12, weight: .medium))
                    .tracking(-0.1)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
            }
            .padding(.bottom, constants.headerBottomPadding)
        }

        // MARK: - Stacked Bar

        private var stackedBar: some View {
            GeometryReader { geo in
                HStack(spacing: 0) {
                    ForEach(config.segments) { segment in
                        let width = geo.size.width * segment.percentage / 100
                        Rectangle()
                            .fill(segment.color.opacity(barOpacity(for: segment.rating)))
                            .frame(width: max(width, 2))
                    }
                }
            }
            .frame(height: constants.barHeight)
            .background(TapZeroDesign.Hairline.default)
            .clipShape(RoundedRectangle(cornerRadius: constants.barCornerRadius))
        }

        private func barOpacity(for rating: PerformanceRating) -> Double {
            switch rating {
            case .perfect: 1.0
            case .good: 0.55
            case .mid: 0.30
            case .bad: 1.0
            }
        }

        // MARK: - Legend

        private var legend: some View {
            VStack(alignment: .leading, spacing: constants.legendRowSpacing) {
                ForEach(config.segments) { segment in
                    legendRow(segment: segment)
                }
            }
            .padding(.top, constants.legendTopPadding)
        }

        private func legendRow(segment: DistributionEntity.DistributionSegment) -> some View {
            HStack(spacing: constants.legendSpacing) {
                Circle()
                    .fill(segment.color.opacity(dotOpacity(for: segment.rating)))
                    .frame(width: constants.legendDotSize, height: constants.legendDotSize)

                Text(ratingLabel(for: segment.rating))
                    .font(.system(size: 13, weight: .semibold))
                    .tracking(-0.1)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)

                Text(ratingRange(for: segment.rating))
                    .font(.system(size: 12, weight: .medium))
                    .tracking(-0.1)
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)

                Spacer()

                Text("\(segment.count)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)

                Text(String(format: "%.0f%%", segment.percentage))
                    .font(.system(size: 13, weight: .bold))
                    .tracking(-0.2)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
                    .frame(width: 32, alignment: .trailing)
            }
        }

        private func dotOpacity(for rating: PerformanceRating) -> Double {
            switch rating {
            case .perfect, .bad: 1.0
            case .good: 0.6
            case .mid: 0.45
            }
        }

        private func ratingLabel(for rating: PerformanceRating) -> String {
            switch rating {
            case .perfect: TextKey.localized("history.rating.perfect")
            case .good: TextKey.localized("history.rating.good")
            case .mid: TextKey.localized("history.rating.mid")
            case .bad: TextKey.localized("history.rating.off")
            }
        }

        private func ratingRange(for rating: PerformanceRating) -> String {
            switch rating {
            case .perfect: "< 0.05s"
            case .good: "< 0.22s"
            case .mid: "< 0.55s"
            case .bad: "> 0.55s"
            }
        }
    }
}

// MARK: - Previews

#Preview("Distribution") {
    HistoryScreen.DistributionView(
        binding: .constant(.init()),
        config: .init(segments: [
            .init(id: "perfect", rating: .perfect, count: 23, percentage: 38, color: TapZeroDesign.History.perfectDisc),
            .init(id: "good", rating: .good, count: 20, percentage: 33, color: TapZeroDesign.History.goodDisc),
            .init(id: "mid", rating: .mid, count: 10, percentage: 17, color: TapZeroDesign.Foreground.secondary),
            .init(id: "bad", rating: .bad, count: 7, percentage: 12, color: TapZeroDesign.History.badDisc)
        ])
    )
    .padding(.horizontal, 20)
    .background(TapZeroDesign.Background.primary)
}
