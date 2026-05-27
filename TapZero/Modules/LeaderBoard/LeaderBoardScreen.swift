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
            .onChange(of: viewModel.headerEntity.binding.selectedTab) { newTab in
                viewModel.onTabChanged(newTab)
            }
            .onChange(of: viewModel.selectedTab) { newTab in
                viewModel.headerEntity.binding.selectedTab = newTab
                viewModel.headerEntity.config = .init(selectedTab: newTab)
            }
    }

    private var contentView: some View {
        ZStack {
            TapZeroDesign.Background.primary.ignoresSafeArea()
            leaderboardContent
        }
    }
}

// MARK: - Leaderboard Content

extension LeaderBoardScreen {
    private var leaderboardContent: some View {
        VStack(spacing: 0) {
            LeaderBoardHeaderView(
                binding: $viewModel.headerEntity.binding,
                config: viewModel.headerEntity.config,
                constants: constants
            )

            TabView(selection: $viewModel.headerEntity.binding.selectedTab) {
                globalPage.tag(LeaderBoardViewModel.LeaderBoardTab.global)
                dailyPage.tag(LeaderBoardViewModel.LeaderBoardTab.daily)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.25), value: viewModel.headerEntity.binding.selectedTab)
        }
        .overlay(alignment: .bottom) {
            if viewModel.showStickyBar {
                StickyBarView(
                    binding: $viewModel.stickyBarEntity.binding,
                    config: viewModel.stickyBarEntity.config,
                    constants: constants
                )
            }
        }
    }
}

// MARK: - Scrollable List

extension LeaderBoardScreen {
    private var globalPage: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    globalPodium
                    globalList
                }
                .padding(.bottom, viewModel.showStickyBar ? 100 : 0)
            }
            .blur(radius: viewModel.isLocked ? 8 : 0)
            .opacity(viewModel.isLocked ? 0.55 : 1)
            .disabled(viewModel.isLocked)

            if viewModel.isLocked {
                LockedOverlayView(
                    binding: $viewModel.lockedOverlayEntity.binding,
                    config: viewModel.lockedOverlayEntity.config,
                    constants: constants
                ) { action in
                    switch action {
                    case .didTapPlayGame:
                        viewModel.onPlayGameTapped()
                    }
                }
            }
        }
    }

    private var dailyPage: some View {
        ScrollView {
            VStack(spacing: 0) {
                dailyResetTimer
                dailyPodiumSection
                dailyList
            }
        }
    }
}

// MARK: - Global Content

extension LeaderBoardScreen {
    private var globalPodium: some View {
        PodiumView(
            binding: $viewModel.globalPodiumEntity.binding,
            config: viewModel.globalPodiumEntity.config,
            constants: constants
        )
    }

    private var globalList: some View {
        LazyVStack(spacing: constants.rowMarginBottom) {
            ForEach(viewModel.globalList) { entry in
                globalRow(entry: entry)
            }
        }
        .padding(.horizontal, constants.listHorizontalPadding)
    }

    private func globalRow(entry: GlobalLeaderboardEntry) -> some View {
        LeaderBoardRowView(
            binding: .constant(.init()),
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
}

// MARK: - Daily Content

extension LeaderBoardScreen {
    private var dailyPodiumSection: some View {
        PodiumView(
            binding: $viewModel.dailyPodiumEntity.binding,
            config: viewModel.dailyPodiumEntity.config,
            constants: constants
        )
    }

    private var dailyList: some View {
        LazyVStack(spacing: constants.rowMarginBottom) {
            ForEach(viewModel.dailyList) { entry in
                dailyRow(entry: entry)
            }
        }
        .padding(.horizontal, constants.listHorizontalPadding)
    }

    private func dailyRow(entry: DailyLeaderboardEntry) -> some View {
        LeaderBoardRowView(
            binding: .constant(.init()),
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
        let timeLeft = TextKey.LeaderBoard.dailyTimeLeft(
            hours: remaining.hours,
            minutes: remaining.minutes
        )
        return "\(resetsAt) · \(timeLeft)"
    }
}

// MARK: - Preview Helpers

private struct LeaderBoardPreview: View {
    let showSticky: Bool
    let isGlobalLocked: Bool

    @State private var selectedTab: LeaderBoardViewModel.LeaderBoardTab

    init(
        tab: LeaderBoardViewModel.LeaderBoardTab = .global,
        showSticky: Bool = false,
        isGlobalLocked: Bool = false
    ) {
        self.showSticky = showSticky
        self.isGlobalLocked = isGlobalLocked
        _selectedTab = State(initialValue: tab)
    }

    private let constants = LeaderBoardScreen.Constants()

    var body: some View {
        ZStack {
            TapZeroDesign.Background.primary.ignoresSafeArea()

            VStack(spacing: 0) {
                LeaderBoardScreen.LeaderBoardHeaderView(
                    binding: .constant(.init(selectedTab: selectedTab)),
                    config: .init(selectedTab: selectedTab),
                    constants: constants
                )

                TabView(selection: $selectedTab) {
                    previewGlobalPage
                        .tag(LeaderBoardViewModel.LeaderBoardTab.global)
                    previewDailyPage
                        .tag(LeaderBoardViewModel.LeaderBoardTab.daily)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.25), value: selectedTab)
            }
            .overlay(alignment: .bottom) {
                if showSticky && selectedTab == .global {
                    stickyBar
                }
            }
        }
    }

    // MARK: - Global Page

    private var previewGlobalPage: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    LeaderBoardScreen.PodiumView(
                        binding: .constant(.init()),
                        config: .init(entries: globalPodium),
                        constants: constants
                    )
                    globalListRows
                }
                .padding(.bottom, showSticky ? 100 : 0)
            }
            .blur(radius: isGlobalLocked ? 8 : 0)
            .opacity(isGlobalLocked ? 0.55 : 1)
            .disabled(isGlobalLocked)

            if isGlobalLocked { lockedOverlay }
        }
    }

    // MARK: - Daily Page

    private var previewDailyPage: some View {
        ScrollView {
            VStack(spacing: 0) {
                dailyTimer
                LeaderBoardScreen.PodiumView(
                    binding: .constant(.init()),
                    config: .init(entries: dailyPodium),
                    constants: constants
                )
                dailyListRows
            }
        }
    }

    // MARK: - Shared Components

    private var stickyBar: some View {
        LeaderBoardScreen.StickyBarView(
            binding: .constant(.init()),
            config: .init(
                rank: 147, score: 782, name: "Burak",
                avatarURL: nil, colorHex: "#007AFF",
                climbCount: 97, listLimit: 50
            ),
            constants: constants
        )
    }

    private var lockedOverlay: some View {
        LeaderBoardScreen.LockedOverlayView(
            binding: .constant(.init()),
            config: .init(
                gamesPlayed: 4, gamesRequired: 10,
                gamesRemaining: 6, progress: 0.4
            ),
            constants: constants
        ) { _ in }
    }

    private var dailyTimer: some View {
        HStack(spacing: 6) {
            Image(systemName: "clock")
                .font(.system(size: 12))
                .foregroundStyle(TapZeroDesign.Foreground.tertiary)
            Text("Resets at 00:00 · 6h 42m left")
                .font(TapZeroTypography.Caption.regular)
                .foregroundStyle(TapZeroDesign.Foreground.tertiary)
        }
        .padding(.horizontal, 20).padding(.bottom, 10)
    }

    // MARK: - List Rows

    private var globalListRows: some View {
        LazyVStack(spacing: constants.rowMarginBottom) {
            ForEach(globalRows) { entry in
                LeaderBoardScreen.LeaderBoardRowView(
                    binding: .constant(.init()),
                    config: entry, constants: constants
                )
            }
        }
        .padding(.horizontal, constants.listHorizontalPadding)
    }

    private var dailyListRows: some View {
        LazyVStack(spacing: constants.rowMarginBottom) {
            ForEach(dailyRows) { entry in
                LeaderBoardScreen.LeaderBoardRowView(
                    binding: .constant(.init()),
                    config: entry, constants: constants
                )
            }
        }
        .padding(.horizontal, constants.listHorizontalPadding)
    }

    // MARK: - Mock Data Helpers

    private func podium(
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
            avatarURL: nil, avatarColor: Color(hex: pastel),
            medalColor: medal, ribbonTextColor: ribbon
        )
    }

    private func row(
        rank: Int, name: String, score: Int,
        colorHex: String? = nil, isUser: Bool = false
    ) -> LeaderBoardScreen.LeaderBoardRowEntity.Config {
        .init(
            rank: rank, name: name, score: score,
            avatarURL: nil, colorHex: colorHex,
            isCurrentUser: isUser, isDense: false
        )
    }

    // MARK: - Global Mock (top10Average, max 1000)

    private var globalPodium: [LeaderBoardScreen.PodiumEntity.PodiumEntry] {
        [
            podium(rank: 1, name: "Mira Stone", score: 984),
            podium(rank: 2, name: "Kenji Park", score: 971),
            podium(rank: 3, name: "Yuna Choi", score: 958)
        ]
    }

    private var globalRows: [LeaderBoardScreen.LeaderBoardRowEntity.Config] {
        [
            row(rank: 4, name: "Liam Carter", score: 932),
            row(rank: 5, name: "Sofia Rossi", score: 918),
            row(rank: 6, name: "Noah Kim", score: 904),
            row(rank: 7, name: "Burak", score: 891, colorHex: "#007AFF", isUser: true),
            row(rank: 8, name: "Emma Liu", score: 876),
            row(rank: 9, name: "Raj Patel", score: 854),
            row(rank: 10, name: "Ava Chen", score: 837)
        ]
    }

    // MARK: - Daily Mock (bestScore, max 1000)

    private var dailyPodium: [LeaderBoardScreen.PodiumEntity.PodiumEntry] {
        [
            podium(rank: 1, name: "Kenji Park", score: 998),
            podium(rank: 2, name: "Sofia Rossi", score: 994),
            podium(rank: 3, name: "Liam Carter", score: 987)
        ]
    }

    private var dailyRows: [LeaderBoardScreen.LeaderBoardRowEntity.Config] {
        [
            row(rank: 4, name: "Yuna Choi", score: 976),
            row(rank: 5, name: "Mira Stone", score: 965),
            row(rank: 6, name: "Emma Liu", score: 958),
            row(rank: 7, name: "Noah Kim", score: 951),
            row(rank: 8, name: "Raj Patel", score: 947),
            row(rank: 9, name: "Burak", score: 942, colorHex: "#007AFF", isUser: true),
            row(rank: 10, name: "Ava Chen", score: 931)
        ]
    }
}

// MARK: - Screen Previews

#Preview("6.1 — Global") {
    LeaderBoardPreview()
}

#Preview("6.2 — Daily") {
    LeaderBoardPreview(tab: .daily)
}

#Preview("6.3 — Sticky") {
    LeaderBoardPreview(showSticky: true)
}

#Preview("6.4 — Locked") {
    LeaderBoardPreview(isGlobalLocked: true)
}
