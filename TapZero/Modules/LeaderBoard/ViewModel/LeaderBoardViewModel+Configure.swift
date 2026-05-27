//
//  LeaderBoardViewModel+Configure.swift
//  TapZero
//

import SwiftUI

// MARK: - Configure
extension LeaderBoardViewModel {
    func configure() {
        configureHeader()
        configureGlobalPodium()
        configureDailyPodium()
        configureStickyBar()
        configureLockedOverlay()
    }

    private func configureHeader() {
        headerEntity.config = .init(selectedTab: selectedTab)
    }

    private func configureGlobalPodium() {
        globalPodiumEntity.config = .init(
            entries: globalPodium.map { entry in
                .init(
                    rank: entry.rank,
                    name: entry.name,
                    score: entry.top10Average,
                    avatarURL: entry.avatar,
                    avatarColor: avatarColor(for: entry.name, colorHex: nil),
                    medalColor: medalColor(for: entry.rank),
                    ribbonTextColor: ribbonTextColor(for: entry.rank)
                )
            }
        )
    }

    private func configureDailyPodium() {
        dailyPodiumEntity.config = .init(
            entries: dailyPodium.map { entry in
                .init(
                    rank: entry.rank,
                    name: entry.name,
                    score: entry.bestScore,
                    avatarURL: entry.avatar,
                    avatarColor: avatarColor(for: entry.name, colorHex: nil),
                    medalColor: medalColor(for: entry.rank),
                    ribbonTextColor: ribbonTextColor(for: entry.rank)
                )
            }
        )
    }

    private func configureStickyBar() {
        stickyBarEntity.config = .init(
            rank: stickyRank,
            score: stickyScore,
            name: currentUserName,
            avatarURL: currentUserAvatar,
            colorHex: currentUserColorHex,
            climbCount: climbCount,
            listLimit: listLimit
        )
    }

    private func configureLockedOverlay() {
        lockedOverlayEntity.config = .init(
            gamesPlayed: gamesPlayed,
            gamesRequired: unlockRequiredGames,
            gamesRemaining: gamesRemaining,
            progress: unlockProgress
        )
    }
}
