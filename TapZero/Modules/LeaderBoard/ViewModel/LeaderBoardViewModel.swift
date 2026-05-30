//
//  LeaderBoardViewModel.swift
//  TapZero
//

import Combine
import SwiftfulRouting
import SwiftUI

@MainActor
final class LeaderBoardViewModel: ObservableObject {
    // MARK: - Non-Published Properties
    var didAppearOnce: Bool = false
    let router: Router
    let entity: LeaderBoardEntity

    // MARK: - Managers
    @Injected private(set) var eventManager: EventManager
    @Injected private(set) var gameManager: GameManager
    @Injected private(set) var userManager: UserManager
    @Injected private(set) var crashReporter: CrashReporterProtocol
    @Injected private(set) var deepLinkManager: DeepLinkManager

    // MARK: - Published Properties
    @Published var selectedTab: LeaderBoardTab = .global
    @Published var isLoading: Bool = false

    // MARK: - Subview Entities
    @Published var headerEntity: LeaderBoardScreen.LeaderBoardHeaderEntity = .init(
        binding: .init(),
        config: .init(selectedTab: .global)
    )
    @Published var globalPodiumEntity: LeaderBoardScreen.PodiumEntity = .init(
        binding: .init(),
        config: .init(entries: [])
    )
    @Published var dailyPodiumEntity: LeaderBoardScreen.PodiumEntity = .init(
        binding: .init(),
        config: .init(entries: [])
    )
    @Published var stickyBarEntity: LeaderBoardScreen.StickyBarEntity = .init(
        binding: .init(),
        config: .init(rank: 0, score: 0, name: "", avatarURL: nil, avatarColor: .clear, climbCount: 0, listLimit: 0)
    )
    @Published var lockedOverlayEntity: LeaderBoardScreen.LockedOverlayEntity = .init(
        binding: .init(),
        config: .init(gamesPlayed: 0, gamesRequired: 10, gamesRemaining: 10, progress: 0)
    )
    @Published var globalEmptyEntity: LeaderBoardScreen.EmptyStateEntity = .init(
        binding: .init(),
        config: .init(
            headline: TextKey.LeaderBoard.emptyGlobalTitle,
            subtitle: TextKey.LeaderBoard.emptyGlobalSubtitle
        )
    )
    @Published var dailyEmptyEntity: LeaderBoardScreen.EmptyStateEntity = .init(
        binding: .init(),
        config: .init(
            headline: TextKey.LeaderBoard.emptyDailyTitle,
            subtitle: TextKey.LeaderBoard.emptyDailySubtitle
        )
    )

    @Published var yourSpotEntity: LeaderBoardScreen.YourSpotRowEntity = .init(
        binding: .init(),
        config: .init(label: TextKey.LeaderBoard.yourSpotWaiting)
    )

    // MARK: - Init
    init(
        router: Router,
        entity: LeaderBoardEntity
    ) {
        self.router = router
        self.entity = entity
    }
}

// MARK: - Tab Enum
extension LeaderBoardViewModel {
    enum LeaderBoardTab: Int, CaseIterable {
        case global, daily
    }
}

// MARK: - Computed Properties
extension LeaderBoardViewModel {
    // MARK: - Data
    var globalEntries: [GlobalLeaderboardEntry] { gameManager.globalLeaderboard }
    var dailyEntries: [DailyLeaderboardEntry] { gameManager.dailyLeaderboard }
    var userStats: UserStatsModel? { gameManager.userStats }
    var currentUserId: String? { userManager.currentUser?.userId }
    var currentUserName: String { userManager.currentUser?.displayName ?? "" }
    var currentUserAvatar: String? { userManager.currentUser?.profileImageURL }
    var currentUserColorHex: String? { userManager.currentUser?.profileColorHex }

    // MARK: - Locked State (only Global)
    var isLocked: Bool {
        selectedTab == .global
            && (userStats?.totalGamesPlayed ?? 0) < unlockRequiredGames
    }
    var gamesPlayed: Int { userStats?.totalGamesPlayed ?? 0 }
    var unlockRequiredGames: Int { 10 }
    var gamesRemaining: Int { max(0, unlockRequiredGames - gamesPlayed) }
    var unlockProgress: CGFloat { CGFloat(gamesPlayed) / CGFloat(unlockRequiredGames) }

    // MARK: - Empty State
    var isGlobalEmpty: Bool { globalEntries.isEmpty }
    var isDailyEmpty: Bool { dailyEntries.isEmpty }

    var showGlobalSpotRow: Bool {
        let count = globalEntries.count
        return count > 0 && count < 4
    }

    var showDailySpotRow: Bool {
        let count = dailyEntries.count
        return count > 0 && count < 4
    }

    var isUserInGlobalPodium: Bool {
        guard let userId = currentUserId else { return false }
        return globalEntries.contains { $0.userId == userId }
    }

    var isUserInDailyPodium: Bool {
        guard let userId = currentUserId else { return false }
        return dailyEntries.contains { $0.userId == userId }
    }

    // MARK: - Podium & List Split
    var globalPodium: [GlobalLeaderboardEntry] { Array(globalEntries.prefix(3)) }
    var globalList: [GlobalLeaderboardEntry] { Array(globalEntries.dropFirst(3)) }
    var dailyPodium: [DailyLeaderboardEntry] { Array(dailyEntries.prefix(3)) }
    var dailyList: [DailyLeaderboardEntry] { Array(dailyEntries.dropFirst(3)) }

    // MARK: - Sticky Bar
    var userGlobalRank: Int? { userStats?.globalRank }
    var userDailyRank: Int? { userStats?.dailyRank }

    var isUserInGlobalList: Bool {
        guard let userId = currentUserId else { return false }
        return globalEntries.contains { $0.userId == userId }
    }

    var isUserInDailyList: Bool {
        guard let userId = currentUserId else { return false }
        return dailyEntries.contains { $0.userId == userId }
    }

    var showStickyBar: Bool {
        guard !isLoading, !isLocked else { return false }
        let rank: Int? = selectedTab == .global ? userGlobalRank : userDailyRank
        guard let rank, rank > 0 else { return false }
        return selectedTab == .global ? !isUserInGlobalList : !isUserInDailyList
    }

    var stickyRank: Int {
        (selectedTab == .global ? userGlobalRank : userDailyRank) ?? 0
    }

    var stickyScore: Int {
        selectedTab == .global
            ? (userStats?.top10Average ?? 0)
            : (userStats?.dailyBestScore ?? 0)
    }

    var climbCount: Int {
        let listCount = selectedTab == .global ? globalEntries.count : dailyEntries.count
        return max(0, stickyRank - listCount)
    }

    var listLimit: Int {
        selectedTab == .global ? globalEntries.count : dailyEntries.count
    }

    // MARK: - Daily Timer
    var dailyResetTimeRemaining: (hours: Int, minutes: Int) {
        let calendar = Calendar.current
        let now = Date()
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now)) else {
            return (0, 0)
        }
        let components = calendar.dateComponents([.hour, .minute], from: now, to: tomorrow)
        return (components.hour ?? 0, components.minute ?? 0)
    }

    // MARK: - Podium Colors
    func medalColor(for rank: Int) -> Color {
        switch rank {
        case 1: TapZeroDesign.Medal.gold
        case 2: TapZeroDesign.Medal.silver
        case 3: TapZeroDesign.Medal.bronze
        default: TapZeroDesign.Foreground.tertiary
        }
    }

    func ribbonTextColor(for rank: Int) -> Color {
        switch rank {
        case 1, 2: TapZeroDesign.Foreground.primary
        case 3: Color(hex: TapZeroPalette.Neutral.N50)
        default: TapZeroDesign.Foreground.primary
        }
    }

    func avatarColor(colorHex: String?) -> Color {
        if let hex = colorHex {
            return Color(hex: hex)
        }
        return TapZeroDesign.Foreground.tertiary
    }
}
