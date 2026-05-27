//
//  StickyBarView.swift
//  TapZero
//

import SwiftUI

extension LeaderBoardScreen {
    struct StickyBarView: View, Equatable {
        let config: StickyBarEntity.Config
        let constants: Constants

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config
        }

        private var accentColor: Color { TapZeroDesign.Status.good }

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                headerRow
                    .padding(.bottom, constants.stickyHeaderBottomSpacing)

                LeaderBoardRowView(
                    config: .init(
                        rank: config.rank,
                        name: config.name,
                        score: config.score,
                        avatarURL: config.avatarURL,
                        colorHex: config.colorHex,
                        isCurrentUser: true,
                        isDense: true
                    ),
                    constants: constants
                )
            }
            .padding(.horizontal, constants.stickyPaddingH)
            .padding(.top, constants.stickyPaddingTop)
            .padding(.bottom, constants.stickyPaddingBottom)
            .background(
                TapZeroDesign.Background.primary
                    .opacity(0.9)
            )
            .background(.ultraThinMaterial)
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(TapZeroDesign.Hairline.default)
                    .frame(height: 0.5)
            }
        }

        // MARK: - Header

        private var headerRow: some View {
            HStack {
                Text(TextKey.LeaderBoard.yourRanking)
                    .font(TapZeroTypography.Caption.sectionHeader)
                    .tracking(constants.stickyHeaderTracking)
                    .textCase(.uppercase)
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)

                Spacer()

                if config.climbCount > 0 {
                    Text("↑ " + String(
                        format: TextKey.LeaderBoard.climbHint,
                        config.climbCount,
                        config.listLimit
                    ))
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(0.4)
                    .foregroundStyle(accentColor)
                }
            }
            .padding(.horizontal, 4)
        }
    }
}

// MARK: - Previews

#Preview("Sticky Bar — Climb Hint") {
    LeaderBoardScreen.StickyBarView(
        config: .init(
            rank: 147, score: 7200, name: "Burak",
            avatarURL: nil, colorHex: "#007AFF",
            climbCount: 97, listLimit: 50
        ),
        constants: .init()
    )
    .background(TapZeroDesign.Background.primary)
}

#Preview("Sticky Bar — No Climb") {
    LeaderBoardScreen.StickyBarView(
        config: .init(
            rank: 51, score: 8500, name: "Burak",
            avatarURL: nil, colorHex: "#007AFF",
            climbCount: 0, listLimit: 50
        ),
        constants: .init()
    )
    .background(TapZeroDesign.Background.primary)
}
