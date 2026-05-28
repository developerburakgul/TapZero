//
//  StickyBarView.swift
//  TapZero
//

import SwiftUI

extension LeaderBoardScreen {
    struct StickyBarView: View, Equatable {
        @Binding var binding: StickyBarEntity.Binding
        let config: StickyBarEntity.Config
        private let constants = Constants()

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config
        }

        private var accentColor: Color { TapZeroDesign.Status.good }

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                headerRow
                    .padding(.bottom, constants.headerBottomSpacing)

                LeaderBoardRowView(
                    binding: .constant(.init()),
                    config: .init(
                        rank: config.rank,
                        name: config.name,
                        score: config.score,
                        avatarURL: config.avatarURL,
                        avatarColor: config.avatarColor,
                        isCurrentUser: true,
                        isDense: true
                    )
                )
            }
            .padding(.horizontal, constants.paddingH)
            .padding(.top, constants.paddingTop)
            .padding(.bottom, constants.paddingBottom)
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
                    .tracking(constants.headerTracking)
                    .textCase(.uppercase)
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)

                Spacer()

                if config.climbCount > 0, config.climbCount < 100 {
                    Text("↑ " + TextKey.LeaderBoard.climbHint(
                        climb: config.climbCount,
                        limit: config.listLimit
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

private struct StickyBarPreview: View {
    @State private var entity: LeaderBoardScreen.StickyBarEntity

    init(config: LeaderBoardScreen.StickyBarEntity.Config) {
        _entity = State(initialValue: .init(binding: .init(), config: config))
    }

    var body: some View {
        LeaderBoardScreen.StickyBarView(
            binding: $entity.binding,
            config: entity.config
        )
        .background(TapZeroDesign.Background.primary)
    }
}

#Preview("Close to List — Climb 12") {
    StickyBarPreview(config: .init(
        rank: 62, score: 834, name: "Burak",
        avatarURL: nil, avatarColor: Color(hex: "#007AFF"),
        climbCount: 12, listLimit: 50
    ))
}

#Preview("Far from List — No Hint") {
    StickyBarPreview(config: .init(
        rank: 230, score: 512, name: "Burak",
        avatarURL: nil, avatarColor: Color(hex: "#007AFF"),
        climbCount: 180, listLimit: 50
    ))
}

#Preview("Just Outside — Climb 1") {
    StickyBarPreview(config: .init(
        rank: 51, score: 890, name: "Burak",
        avatarURL: nil, avatarColor: Color(hex: "#007AFF"),
        climbCount: 1, listLimit: 50
    ))
}
