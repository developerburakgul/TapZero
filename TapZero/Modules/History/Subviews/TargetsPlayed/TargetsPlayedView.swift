//
//  TargetsPlayedView.swift
//  TapZero
//

import SwiftUI

extension HistoryScreen {
    struct TargetsPlayedView: View, Equatable {
        @Binding var binding: TargetsPlayedEntity.Binding
        let config: TargetsPlayedEntity.Config
        private let constants = Constants()

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config && lhs.binding == rhs.binding
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                headerRow
                targetRows
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
                Text(TextKey.History.statTargetsPlayed)
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1.2)
                    .textCase(.uppercase)
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)
                Spacer()
                Text(TextKey.History.targetsTop5)
                    .font(.system(size: 12, weight: .medium))
                    .tracking(-0.1)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
            }
            .padding(.bottom, constants.headerBottomPadding)
        }

        // MARK: - Rows

        private var targetRows: some View {
            VStack(spacing: constants.rowSpacing) {
                ForEach(config.targets) { target in
                    targetRow(target: target)
                }
            }
        }

        private func targetRow(target: TargetsPlayedEntity.TargetStat) -> some View {
            HStack(spacing: constants.rowGap) {
                Text(target.targetLabel)
                    .font(.system(size: 14, weight: .bold))
                    .tracking(-0.3)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
                    .frame(width: constants.targetLabelWidth, alignment: .leading)

                progressBar(fraction: target.barFraction)

                Text("\(target.playCount)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
                    .frame(width: constants.countWidth, alignment: .trailing)

                Text("\(target.bestScore)")
                    .font(.system(size: 12, weight: .bold))
                    .tracking(-0.1)
                    .foregroundStyle(TapZeroDesign.Status.good)
                    .frame(width: constants.bestScoreWidth, alignment: .trailing)
            }
        }

        private func progressBar(fraction: Double) -> some View {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: constants.barCornerRadius)
                        .fill(TapZeroDesign.Hairline.default)

                    RoundedRectangle(cornerRadius: constants.barCornerRadius)
                        .fill(TapZeroDesign.Foreground.primary)
                        .frame(width: geo.size.width * fraction)
                }
            }
            .frame(height: constants.barHeight)
        }
    }
}

// MARK: - Previews

#Preview("Targets Played") {
    HistoryScreen.TargetsPlayedView(
        binding: .constant(.init()),
        config: .init(targets: [
            .init(id: 5, targetLabel: "5s", playCount: 18, bestScore: 912, barFraction: 1.0),
            .init(id: 12, targetLabel: "12s", playCount: 12, bestScore: 885, barFraction: 0.67),
            .init(id: 20, targetLabel: "20s", playCount: 8, bestScore: 770, barFraction: 0.44),
            .init(id: 8, targetLabel: "8s", playCount: 5, bestScore: 740, barFraction: 0.28),
            .init(id: 30, targetLabel: "30s", playCount: 2, bestScore: 650, barFraction: 0.11)
        ])
    )
    .padding(.horizontal, 20)
    .background(TapZeroDesign.Background.primary)
}
