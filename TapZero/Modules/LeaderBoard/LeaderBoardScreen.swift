//
//  LeaderBoardScreen.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

struct LeaderBoardScreen: View {
    // MARK: - Private properties
    private let constants = Constants()

    // MARK: - Observed properties
    @StateObject var viewModel: LeaderBoardViewModel

    var body: some View {
        contentView
            .task {
                if !viewModel.didAppearOnce {
                    viewModel.didAppearOnce = true
                    await viewModel.viewDidLoad()
                }
                await viewModel.viewWillAppear()
            }
    }

    private var contentView: some View {
        ZStack {
            TapZeroDesign.Background.primary.ignoresSafeArea()

            if viewModel.isLocked {
                lockedView
            } else {
                leaderboardContent
            }
        }
    }
}

// MARK: - Leaderboard Content

extension LeaderBoardScreen {
    private var leaderboardContent: some View {
        VStack(spacing: 0) {
            LeaderBoardHeaderView(
                config: .init(selectedTab: viewModel.selectedTab),
                selectedTab: $viewModel.selectedTab,
                constants: constants
            )

            scrollableList
        }
        .overlay(alignment: .bottom) {
            if viewModel.showStickyBar {
                StickyBarView(
                    config: .init(
                        rank: viewModel.stickyRank,
                        score: viewModel.stickyScore,
                        name: viewModel.currentUserName,
                        avatarURL: viewModel.currentUserAvatar,
                        colorHex: viewModel.currentUserColorHex,
                        climbCount: viewModel.climbCount,
                        listLimit: viewModel.listLimit
                    ),
                    constants: constants
                )
            }
        }
    }
}

// MARK: - Scrollable List

extension LeaderBoardScreen {
    private var scrollableList: some View {
        ScrollView {
            VStack(spacing: 0) {
                if viewModel.selectedTab == .daily {
                    dailyResetTimer
                }

                podiumSection

                listSection

                if viewModel.showStickyBar {
                    showingTopLabel
                }
            }
            .padding(.bottom, viewModel.showStickyBar ? 100 : 0)
        }
    }

    private var podiumSection: some View {
        Group {
            switch viewModel.selectedTab {
            case .global:
                PodiumView(
                    config: .init(entries: viewModel.globalPodium.map { entry in
                        podiumEntry(
                            rank: entry.rank, name: entry.name,
                            score: entry.top10Average, avatarURL: entry.avatar
                        )
                    }),
                    constants: constants
                )
            case .daily:
                PodiumView(
                    config: .init(entries: viewModel.dailyPodium.map { entry in
                        podiumEntry(
                            rank: entry.rank, name: entry.name,
                            score: entry.bestScore, avatarURL: entry.avatar
                        )
                    }),
                    constants: constants
                )
            }
        }
    }

    private func podiumEntry(
        rank: Int, name: String, score: Int, avatarURL: String?
    ) -> LeaderBoardScreen.PodiumEntity.PodiumEntry {
        .init(
            rank: rank,
            name: name,
            score: score,
            avatarURL: avatarURL,
            avatarColor: viewModel.avatarColor(for: name, colorHex: nil),
            medalColor: viewModel.medalColor(for: rank),
            ribbonTextColor: viewModel.ribbonTextColor(for: rank)
        )
    }

    private var listSection: some View {
        LazyVStack(spacing: constants.rowMarginBottom) {
            switch viewModel.selectedTab {
            case .global:
                ForEach(viewModel.globalList) { entry in
                    globalRow(entry: entry)
                }
            case .daily:
                ForEach(viewModel.dailyList) { entry in
                    dailyRow(entry: entry)
                }
            }
        }
        .padding(.horizontal, constants.listHorizontalPadding)
    }

    private func globalRow(entry: GlobalLeaderboardEntry) -> some View {
        LeaderBoardRowView(
            config: .init(
                rank: entry.rank,
                name: entry.name,
                score: entry.top10Average,
                avatarURL: entry.avatar,
                colorHex: nil,
                isCurrentUser: entry.userId == viewModel.currentUserId,
                isDense: false
            ),
            constants: constants
        )
    }

    private func dailyRow(entry: DailyLeaderboardEntry) -> some View {
        LeaderBoardRowView(
            config: .init(
                rank: entry.rank,
                name: entry.name,
                score: entry.bestScore,
                avatarURL: entry.avatar,
                colorHex: nil,
                isCurrentUser: entry.userId == viewModel.currentUserId,
                isDense: false
            ),
            constants: constants
        )
    }
}

// MARK: - Daily Reset Timer

extension LeaderBoardScreen {
    private var dailyResetTimer: some View {
        HStack(spacing: 6) {
            Image(systemName: "clock")
                .font(.system(size: constants.dailyClockSize))
                .foregroundStyle(TapZeroDesign.Foreground.tertiary)

            Text(dailyTimerText)
                .font(TapZeroTypography.Caption.regular)
                .foregroundStyle(TapZeroDesign.Foreground.tertiary)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }

    private var dailyTimerText: String {
        let remaining = viewModel.dailyResetTimeRemaining
        let resetsAt = TextKey.LeaderBoard.dailyResetsAt
        let timeLeft = String(
            format: TextKey.LeaderBoard.dailyTimeLeft,
            remaining.hours,
            remaining.minutes
        )
        return "\(resetsAt) · \(timeLeft)"
    }
}

// MARK: - Showing Top Label

extension LeaderBoardScreen {
    private var showingTopLabel: some View {
        Text(String(
            format: TextKey.LeaderBoard.showingTop,
            viewModel.listLimit
        ))
        .font(TapZeroTypography.Caption.regular)
        .foregroundStyle(TapZeroDesign.Foreground.tertiary)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
}

// MARK: - Locked View

extension LeaderBoardScreen {
    private var lockedView: some View {
        ZStack {
            leaderboardContent
                .blur(radius: 8)
                .opacity(0.55)
                .disabled(true)

            LockedOverlayView(
                config: .init(
                    gamesPlayed: viewModel.gamesPlayed,
                    gamesRequired: viewModel.unlockRequiredGames,
                    gamesRemaining: viewModel.gamesRemaining,
                    progress: viewModel.unlockProgress
                ),
                constants: constants,
                onPlayGameTapped: viewModel.onPlayGameTapped
            )
        }
    }
}

// MARK: - Preview Helpers

private struct LeaderBoardPreview: View {
    let tab: LeaderBoardViewModel.LeaderBoardTab
    let isLocked: Bool
    let showSticky: Bool

    @State private var selectedTab: LeaderBoardViewModel.LeaderBoardTab

    init(
        tab: LeaderBoardViewModel.LeaderBoardTab = .global,
        isLocked: Bool = false,
        showSticky: Bool = false
    ) {
        self.tab = tab
        self.isLocked = isLocked
        self.showSticky = showSticky
        _selectedTab = State(initialValue: tab)
    }

    private let constants = LeaderBoardScreen.Constants()

    var body: some View {
        ZStack {
            TapZeroDesign.Background.primary.ignoresSafeArea()

            if isLocked {
                lockedView
            } else {
                normalView
            }
        }
    }

    private var normalView: some View {
        VStack(spacing: 0) {
            LeaderBoardScreen.LeaderBoardHeaderView(
                config: .init(selectedTab: selectedTab),
                selectedTab: $selectedTab,
                constants: constants
            )

            ScrollView {
                VStack(spacing: 0) {
                    LeaderBoardScreen.PodiumView(
                        config: .init(entries: mockPodiumEntries),
                        constants: constants
                    )

                    listRows
                }
                .padding(.bottom, showSticky ? 100 : 0)
            }
        }
        .overlay(alignment: .bottom) {
            if showSticky {
                LeaderBoardScreen.StickyBarView(
                    config: .init(
                        rank: 147, score: 7200, name: "Burak",
                        avatarURL: nil, colorHex: "#007AFF",
                        climbCount: 97, listLimit: 50
                    ),
                    constants: constants
                )
            }
        }
    }

    private var listRows: some View {
        LazyVStack(spacing: constants.rowMarginBottom) {
            ForEach(mockListEntries) { entry in
                LeaderBoardScreen.LeaderBoardRowView(
                    config: entry, constants: constants
                )
            }
        }
        .padding(.horizontal, constants.listHorizontalPadding)
    }

    private var lockedView: some View {
        ZStack {
            normalView
                .blur(radius: 8)
                .opacity(0.55)
                .disabled(true)

            LeaderBoardScreen.LockedOverlayView(
                config: .init(
                    gamesPlayed: 4, gamesRequired: 10,
                    gamesRemaining: 6, progress: 0.4
                ),
                constants: constants
            )
        }
    }

    // MARK: - Mock Data

    private func mockPodiumEntry(
        rank: Int, name: String, score: Int
    ) -> LeaderBoardScreen.PodiumEntity.PodiumEntry {
        let medal: Color = switch rank {
        case 1: TapZeroDesign.Medal.gold
        case 2: TapZeroDesign.Medal.silver
        case 3: TapZeroDesign.Medal.bronze
        default: TapZeroDesign.Foreground.tertiary
        }
        let ribbon: Color = rank == 3
            ? Color(hex: TapZeroPalette.Neutral.N50)
            : TapZeroDesign.Foreground.primary
        let pastel = TapZeroPalette.Pastel.all[
            rank % TapZeroPalette.Pastel.all.count
        ]
        return .init(
            rank: rank, name: name, score: score,
            avatarURL: nil,
            avatarColor: Color(hex: pastel),
            medalColor: medal,
            ribbonTextColor: ribbon
        )
    }

    private var mockPodiumEntries: [LeaderBoardScreen.PodiumEntity.PodiumEntry] {
        [
            mockPodiumEntry(rank: 1, name: "Mira Stone", score: 9842),
            mockPodiumEntry(rank: 2, name: "Kenji Park", score: 9710),
            mockPodiumEntry(rank: 3, name: "Yuna Choi", score: 9588)
        ]
    }

    private func mockRow(
        rank: Int, name: String, score: Int,
        colorHex: String? = nil, isUser: Bool = false
    ) -> LeaderBoardScreen.LeaderBoardRowEntity.Config {
        .init(
            rank: rank, name: name, score: score,
            avatarURL: nil, colorHex: colorHex,
            isCurrentUser: isUser, isDense: false
        )
    }

    private var mockListEntries: [LeaderBoardScreen.LeaderBoardRowEntity.Config] {
        [
            mockRow(rank: 4, name: "Liam Carter", score: 9320),
            mockRow(rank: 5, name: "Sofia Rossi", score: 9185),
            mockRow(rank: 6, name: "Noah Kim", score: 9044),
            mockRow(rank: 7, name: "Burak", score: 9182, colorHex: "#007AFF", isUser: true),
            mockRow(rank: 8, name: "Emma Liu", score: 8890),
            mockRow(rank: 9, name: "Raj Patel", score: 8745),
            mockRow(rank: 10, name: "Ava Chen", score: 8600)
        ]
    }
}

// MARK: - Screen Previews

#Preview("6.1 — Global") {
    LeaderBoardPreview(tab: .global)
}

#Preview("6.2 — Daily") {
    LeaderBoardPreview(tab: .daily)
}

#Preview("6.3 — Sticky") {
    LeaderBoardPreview(tab: .global, showSticky: true)
}

#Preview("6.4 — Locked") {
    LeaderBoardPreview(isLocked: true)
}
