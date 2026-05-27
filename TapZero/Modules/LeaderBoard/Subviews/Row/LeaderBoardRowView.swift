//
//  LeaderBoardRowView.swift
//  TapZero
//

import SwiftUI

extension LeaderBoardScreen {
    struct LeaderBoardRowView: View, Equatable {
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
                .frame(width: constants.rowRankWidth)
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
            Circle()
                .fill(config.avatarColor)
                .overlay(
                    Text(config.initials)
                        .font(.system(
                            size: constants.rowAvatarSize * 0.38,
                            weight: .bold
                        ))
                        .tracking(-0.4)
                        .foregroundStyle(TapZeroDesign.Foreground.primary)
                )
        }

        // MARK: - Name

        private var nameLabel: some View {
            Text(config.isCurrentUser ? TextKey.LeaderBoard.you : config.name)
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

#Preview("Normal Row") {
    LeaderBoardScreen.LeaderBoardRowView(
        config: .init(
            rank: 4, name: "Liam Carter", score: 9320,
            avatarURL: nil, colorHex: nil,
            isCurrentUser: false, isDense: false
        ),
        constants: .init()
    )
    .padding(.horizontal, 8)
    .background(TapZeroDesign.Background.primary)
}

#Preview("Current User Row") {
    LeaderBoardScreen.LeaderBoardRowView(
        config: .init(
            rank: 7, name: "Burak", score: 9182,
            avatarURL: nil, colorHex: "#007AFF",
            isCurrentUser: true, isDense: false
        ),
        constants: .init()
    )
    .padding(.horizontal, 8)
    .background(TapZeroDesign.Background.primary)
}

#Preview("Dense Row") {
    LeaderBoardScreen.LeaderBoardRowView(
        config: .init(
            rank: 147, name: "Burak", score: 7200,
            avatarURL: nil, colorHex: "#007AFF",
            isCurrentUser: true, isDense: true
        ),
        constants: .init()
    )
    .padding(.horizontal, 8)
    .background(TapZeroDesign.Background.primary)
}
