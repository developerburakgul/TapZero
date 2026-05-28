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
                avatarColor: viewModel.avatarColor(colorHex: nil),
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
                avatarColor: viewModel.avatarColor(colorHex: nil),
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

private struct MockRow {
    let rank: Int
    let name: String
    let score: Int
    let isUser: Bool
}

private struct MockSticky {
    let rank: Int
    let score: Int
    let climb: Int
}

private struct LeaderBoardPreview: View {
    let globalPodiumData: [(String, Int)]
    let globalRowData: [MockRow]
    let dailyPodiumData: [(String, Int)]
    let dailyRowData: [MockRow]
    let showSticky: Bool
    let stickyConfig: MockSticky?
    let isGlobalLocked: Bool
    let lockedPlayed: Int

    @State private var selectedTab: LeaderBoardViewModel.LeaderBoardTab

    init(
        tab: LeaderBoardViewModel.LeaderBoardTab = .global,
        globalPodium: [(String, Int)] = [],
        globalRows: [MockRow] = [],
        dailyPodium: [(String, Int)] = [],
        dailyRows: [MockRow] = [],
        showSticky: Bool = false,
        stickyConfig: MockSticky? = nil,
        isGlobalLocked: Bool = false,
        lockedPlayed: Int = 4
    ) {
        self.globalPodiumData = globalPodium
        self.globalRowData = globalRows
        self.dailyPodiumData = dailyPodium
        self.dailyRowData = dailyRows
        self.showSticky = showSticky
        self.stickyConfig = stickyConfig
        self.isGlobalLocked = isGlobalLocked
        self.lockedPlayed = lockedPlayed
        _selectedTab = State(initialValue: tab)
    }

    private let constants = LeaderBoardScreen.Constants()

    var body: some View {
        ZStack {
            TapZeroDesign.Background.primary.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                tabPages
            }
            .overlay(alignment: .bottom) {
                if showSticky && selectedTab == .global {
                    stickyBar
                }
            }
        }
    }

    private var header: some View {
        LeaderBoardScreen.LeaderBoardHeaderView(
            binding: .constant(.init(selectedTab: selectedTab)),
            config: .init(selectedTab: selectedTab),
            constants: constants
        )
    }

    private var tabPages: some View {
        TabView(selection: $selectedTab) {
            globalPage.tag(LeaderBoardViewModel.LeaderBoardTab.global)
            dailyPage.tag(LeaderBoardViewModel.LeaderBoardTab.daily)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(.easeInOut(duration: 0.25), value: selectedTab)
    }

    // MARK: - Global Page

    private var globalPage: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    if globalPodiumEntries.count >= 3 {
                        podiumView(entries: globalPodiumEntries)
                    }
                    listView(rows: globalRowConfigs)
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

    private var dailyPage: some View {
        ScrollView {
            VStack(spacing: 0) {
                dailyTimer
                if dailyPodiumEntries.count >= 3 {
                    podiumView(entries: dailyPodiumEntries)
                }
                listView(rows: dailyRowConfigs)
            }
        }
    }

    // MARK: - Shared Components

    private func podiumView(
        entries: [LeaderBoardScreen.PodiumEntity.PodiumEntry]
    ) -> some View {
        LeaderBoardScreen.PodiumView(
            binding: .constant(.init()),
            config: .init(entries: entries),
            constants: constants
        )
    }

    private func listView(
        rows: [LeaderBoardScreen.LeaderBoardRowEntity.Config]
    ) -> some View {
        LazyVStack(spacing: constants.rowMarginBottom) {
            ForEach(rows) { entry in
                LeaderBoardScreen.LeaderBoardRowView(
                    binding: .constant(.init()),
                    config: entry, constants: constants
                )
            }
        }
        .padding(.horizontal, constants.listHorizontalPadding)
    }

    private var stickyBar: some View {
        let cfg = stickyConfig ?? MockSticky(rank: 63, score: 782, climb: 13)
        return LeaderBoardScreen.StickyBarView(
            binding: .constant(.init()),
            config: .init(
                rank: cfg.rank, score: cfg.score, name: "Burak",
                avatarURL: nil, avatarColor: Color(hex: "#007AFF"),
                climbCount: cfg.climb, listLimit: 50
            ),
            constants: constants
        )
    }

    private var lockedOverlay: some View {
        let remaining = max(0, 10 - lockedPlayed)
        return LeaderBoardScreen.LockedOverlayView(
            binding: .constant(.init()),
            config: .init(
                gamesPlayed: lockedPlayed, gamesRequired: 10,
                gamesRemaining: remaining,
                progress: CGFloat(lockedPlayed) / 10.0
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

    // MARK: - Mock Data Builders

    private func makePodium(
        rank: Int, name: String, score: Int
    ) -> LeaderBoardScreen.PodiumEntity.PodiumEntry {
        let medal: Color = switch rank {
        case 1: TapZeroDesign.Medal.gold
        case 2: TapZeroDesign.Medal.silver
        default: TapZeroDesign.Medal.bronze
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

    private var globalPodiumEntries: [LeaderBoardScreen.PodiumEntity.PodiumEntry] {
        globalPodiumData.enumerated().map { idx, pair in
            makePodium(rank: idx + 1, name: pair.0, score: pair.1)
        }
    }

    private var dailyPodiumEntries: [LeaderBoardScreen.PodiumEntity.PodiumEntry] {
        dailyPodiumData.enumerated().map { idx, pair in
            makePodium(rank: idx + 1, name: pair.0, score: pair.1)
        }
    }

    private var globalRowConfigs: [LeaderBoardScreen.LeaderBoardRowEntity.Config] {
        globalRowData.map { mock in
            .init(
                rank: mock.rank, name: mock.name, score: mock.score,
                avatarURL: nil, avatarColor: mock.isUser ? Color(hex: "#007AFF") : TapZeroDesign.Foreground.tertiary,
                isCurrentUser: mock.isUser, isDense: false
            )
        }
    }

    private var dailyRowConfigs: [LeaderBoardScreen.LeaderBoardRowEntity.Config] {
        dailyRowData.map { mock in
            .init(
                rank: mock.rank, name: mock.name, score: mock.score,
                avatarURL: nil, avatarColor: mock.isUser ? Color(hex: "#007AFF") : TapZeroDesign.Foreground.tertiary,
                isCurrentUser: mock.isUser, isDense: false
            )
        }
    }
}

// MARK: - Mock Data Sets

private let fullGlobalPodium: [(String, Int)] = [
    ("Mira Stone", 984), ("Kenji Park", 971), ("Yuna Choi", 958)
]
private let fullGlobalRows: [MockRow] = [
    .init(rank: 4, name: "Liam Carter", score: 932, isUser: false),
    .init(rank: 5, name: "Sofia Rossi", score: 918, isUser: false),
    .init(rank: 6, name: "Noah Kim", score: 904, isUser: false),
    .init(rank: 7, name: "Burak", score: 891, isUser: true),
    .init(rank: 8, name: "Emma Liu", score: 876, isUser: false),
    .init(rank: 9, name: "Raj Patel", score: 854, isUser: false),
    .init(rank: 10, name: "Ava Chen", score: 837, isUser: false)
]
private let fullDailyPodium: [(String, Int)] = [
    ("Kenji Park", 998), ("Sofia Rossi", 994), ("Liam Carter", 987)
]
private let fullDailyRows: [MockRow] = [
    .init(rank: 4, name: "Yuna Choi", score: 976, isUser: false),
    .init(rank: 5, name: "Mira Stone", score: 965, isUser: false),
    .init(rank: 6, name: "Emma Liu", score: 958, isUser: false),
    .init(rank: 7, name: "Noah Kim", score: 951, isUser: false),
    .init(rank: 8, name: "Raj Patel", score: 947, isUser: false),
    .init(rank: 9, name: "Burak", score: 942, isUser: true),
    .init(rank: 10, name: "Ava Chen", score: 931, isUser: false)
]

// MARK: - Screen Previews

#Preview("Full — Global") {
    LeaderBoardPreview(
        globalPodium: fullGlobalPodium,
        globalRows: fullGlobalRows,
        dailyPodium: fullDailyPodium,
        dailyRows: fullDailyRows
    )
}

#Preview("Full — Daily") {
    LeaderBoardPreview(
        tab: .daily,
        globalPodium: fullGlobalPodium,
        globalRows: fullGlobalRows,
        dailyPodium: fullDailyPodium,
        dailyRows: fullDailyRows
    )
}

#Preview("Sticky — User Outside List") {
    LeaderBoardPreview(
        globalPodium: fullGlobalPodium,
        globalRows: fullGlobalRows.filter { !$0.isUser },
        dailyPodium: fullDailyPodium,
        dailyRows: fullDailyRows,
        showSticky: true,
        stickyConfig: .init(rank: 63, score: 834, climb: 13)
    )
}

#Preview("Locked — New User (0/10)") {
    LeaderBoardPreview(
        globalPodium: fullGlobalPodium,
        globalRows: fullGlobalRows.filter { !$0.isUser },
        dailyPodium: [],
        dailyRows: [],
        isGlobalLocked: true,
        lockedPlayed: 0
    )
}

#Preview("Locked — Almost (9/10)") {
    LeaderBoardPreview(
        globalPodium: fullGlobalPodium,
        globalRows: fullGlobalRows.filter { !$0.isUser },
        dailyPodium: fullDailyPodium,
        dailyRows: fullDailyRows.filter { !$0.isUser },
        isGlobalLocked: true,
        lockedPlayed: 9
    )
}

#Preview("Empty — No Players") {
    LeaderBoardPreview()
}

#Preview("Few Players — Only Podium") {
    LeaderBoardPreview(
        globalPodium: [
            ("Mira Stone", 920), ("Kenji Park", 875), ("Yuna Choi", 812)
        ],
        dailyPodium: [
            ("Mira Stone", 965), ("Kenji Park", 940), ("Yuna Choi", 890)
        ]
    )
}

#Preview("Two Players — No Podium") {
    LeaderBoardPreview(
        globalRows: [
            .init(rank: 1, name: "Mira Stone", score: 920, isUser: false),
            .init(rank: 2, name: "Burak", score: 875, isUser: true)
        ],
        dailyRows: [
            .init(rank: 1, name: "Mira Stone", score: 965, isUser: false),
            .init(rank: 2, name: "Burak", score: 940, isUser: true)
        ]
    )
}
