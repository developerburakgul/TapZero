//
//  LeaderBoardRowView.swift
//  TapZero
//

import SwiftUI

extension LeaderBoardScreen {
    struct LeaderBoardRowView: View, Equatable {
        @Binding var binding: LeaderBoardRowEntity.Binding
        let config: LeaderBoardRowEntity.Config
        let constants: Constants

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config
        }

        private var accentColor: Color { TapZeroDesign.Status.good }

        var body: some View {
            HStack(spacing: constants.rowGap) {
                rankLabel
                avatarView
                nameLabel
                Spacer()
                scoreLabel
            }
            .padding(.horizontal, constants.rowPaddingH)
            .padding(.vertical, config.isDense ? constants.rowDensePaddingV : constants.rowPaddingV)
            .background(
                config.isCurrentUser
                    ? accentColor.opacity(0.06)
                    : Color.clear
            )
            .overlay(
                RoundedRectangle(cornerRadius: constants.rowCornerRadius)
                    .stroke(
                        config.isCurrentUser ? accentColor : Color.clear,
                        lineWidth: config.isCurrentUser ? constants.rowUserBorderWidth : 0
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: constants.rowCornerRadius))
        }

        // MARK: - Rank

        private var rankLabel: some View {
            Text("\(config.rank)")
                .font(.system(size: 13, weight: .bold))
                .tracking(constants.rowNameTracking)
                .monospacedDigit()
                .frame(minWidth: constants.rowRankWidth, alignment: .center)
                .foregroundStyle(
                    config.isCurrentUser
                        ? accentColor
                        : TapZeroDesign.Foreground.tertiary
                )
        }

        // MARK: - Avatar

        private var avatarView: some View {
            Group {
                if let urlString = config.avatarURL, let url = URL(string: urlString) {
                    CachedAsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        monogramView
                    }
                } else {
                    monogramView
                }
            }
            .frame(width: constants.rowAvatarSize, height: constants.rowAvatarSize)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(
                        config.isCurrentUser ? accentColor : Color.clear,
                        lineWidth: config.isCurrentUser ? constants.rowUserBorderWidth : 0
                    )
                    .padding(config.isCurrentUser ? -2 : 0)
            )
        }

        private var monogramView: some View {
            InitialAvatarView(
                initial: config.initials,
                size: constants.rowAvatarSize
            )
        }

        // MARK: - Name

        private var nameLabel: some View {
            Text(config.name)
                .font(.system(size: 15, weight: config.isCurrentUser ? .bold : .medium))
                .tracking(constants.rowNameTracking)
                .lineLimit(1)
                .truncationMode(.tail)
                .foregroundStyle(TapZeroDesign.Foreground.primary)
        }

        // MARK: - Score

        private var scoreLabel: some View {
            Text("\(config.score)")
                .font(.system(size: 15, weight: .bold))
                .tracking(constants.rowScoreTracking)
                .monospacedDigit()
                .foregroundStyle(
                    config.isCurrentUser
                        ? accentColor
                        : TapZeroDesign.Foreground.primary
                )
        }
    }
}

// MARK: - Previews

private struct RowPreview: View {
    @State private var entity: LeaderBoardScreen.LeaderBoardRowEntity

    init(config: LeaderBoardScreen.LeaderBoardRowEntity.Config) {
        _entity = State(initialValue: .init(binding: .init(), config: config))
    }

    var body: some View {
        LeaderBoardScreen.LeaderBoardRowView(
            binding: $entity.binding,
            config: entity.config,
            constants: .init()
        )
        .padding(.horizontal, 8)
        .background(TapZeroDesign.Background.primary)
    }
}

#Preview("Other Player") {
    RowPreview(config: .init(
        rank: 4, name: "Liam Carter", score: 932,
        avatarURL: nil, avatarColor: TapZeroDesign.Foreground.tertiary,
        isCurrentUser: false, isDense: false
    ))
}

#Preview("Current User — In List") {
    RowPreview(config: .init(
        rank: 7, name: "Burak", score: 891,
        avatarURL: nil, avatarColor: Color(hex: "#007AFF"),
        isCurrentUser: true, isDense: false
    ))
}

#Preview("Current User — Sticky Bar") {
    RowPreview(config: .init(
        rank: 63, name: "Burak", score: 782,
        avatarURL: nil, avatarColor: Color(hex: "#007AFF"),
        isCurrentUser: true, isDense: true
    ))
}

#Preview("High Rank — Single Digit") {
    RowPreview(config: .init(
        rank: 4, name: "Sofia Rossi", score: 965,
        avatarURL: nil, avatarColor: TapZeroDesign.Foreground.tertiary,
        isCurrentUser: false, isDense: false
    ))
}

#Preview("Low Score") {
    RowPreview(config: .init(
        rank: 48, name: "Raj Patel", score: 412,
        avatarURL: nil, avatarColor: TapZeroDesign.Foreground.tertiary,
        isCurrentUser: false, isDense: false
    ))
}
