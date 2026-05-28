//
//  LeaderBoardScreen+Preview.swift
//  TapZero
//

import SwiftUI

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
            config: .init(selectedTab: selectedTab)
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

    private var isGlobalEmpty: Bool {
        globalPodiumData.isEmpty && globalRowData.isEmpty
    }

    private var isDailyEmpty: Bool {
        dailyPodiumData.isEmpty && dailyRowData.isEmpty
    }

    private var globalPage: some View {
        ZStack {
            if isGlobalEmpty && !isGlobalLocked {
                emptyView(
                    headline: TextKey.LeaderBoard.emptyGlobalTitle,
                    subtitle: TextKey.LeaderBoard.emptyGlobalSubtitle
                )
            } else {
                globalScrollContent
            }
            if isGlobalLocked { lockedOverlay }
        }
    }

    private var showGlobalYourSpot: Bool {
        let count = globalPodiumData.count + globalRowData.count
        return count > 0 && count < 4 && !globalRowData.contains { $0.isUser }
    }

    private var showDailyYourSpot: Bool {
        let count = dailyPodiumData.count + dailyRowData.count
        return count > 0 && count < 4 && !dailyRowData.contains { $0.isUser }
    }

    private var globalScrollContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                if !globalPodiumEntries.isEmpty {
                    podiumView(entries: globalPodiumEntries)
                }
                if showGlobalYourSpot {
                    LeaderBoardScreen.YourSpotRowView(
                        binding: .constant(.init()), config: .init()
                    )
                }
                listView(rows: globalRowConfigs)
            }
            .padding(.bottom, showSticky ? 100 : 0)
        }
        .blur(radius: isGlobalLocked ? 8 : 0)
        .opacity(isGlobalLocked ? 0.55 : 1)
        .disabled(isGlobalLocked)
    }

    @ViewBuilder
    private var dailyPage: some View {
        if isDailyEmpty {
            VStack(spacing: 0) {
                dailyTimer
                emptyView(
                    headline: TextKey.LeaderBoard.emptyDailyTitle,
                    subtitle: TextKey.LeaderBoard.emptyDailySubtitle
                )
            }
        } else {
            ScrollView {
                VStack(spacing: 0) {
                    dailyTimer
                    if !dailyPodiumEntries.isEmpty {
                        podiumView(entries: dailyPodiumEntries)
                    }
                    if showDailyYourSpot {
                        LeaderBoardScreen.YourSpotRowView(
                            binding: .constant(.init()), config: .init()
                        )
                    }
                    listView(rows: dailyRowConfigs)
                }
            }
        }
    }

    private func emptyView(
        headline: LocalizedStringKey,
        subtitle: LocalizedStringKey
    ) -> some View {
        LeaderBoardScreen.EmptyStateView(
            binding: .constant(.init()),
            config: .init(headline: headline, subtitle: subtitle)
        ) { _ in }
    }

    // MARK: - Shared Components

    private func podiumView(
        entries: [LeaderBoardScreen.PodiumEntity.PodiumEntry]
    ) -> some View {
        LeaderBoardScreen.PodiumView(
            binding: .constant(.init()),
            config: .init(entries: entries)
        )
    }

    private func listView(
        rows: [LeaderBoardScreen.LeaderBoardRowEntity.Config]
    ) -> some View {
        LazyVStack(spacing: constants.rowMarginBottom) {
            ForEach(rows) { entry in
                LeaderBoardScreen.LeaderBoardRowView(
                    binding: .constant(.init()),
                    config: entry
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
            )
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
            )
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
        globalPodiumData.enumerated().map { makePodium(rank: $0 + 1, name: $1.0, score: $1.1) }
    }

    private var dailyPodiumEntries: [LeaderBoardScreen.PodiumEntity.PodiumEntry] {
        dailyPodiumData.enumerated().map { makePodium(rank: $0 + 1, name: $1.0, score: $1.1) }
    }

    private var globalRowConfigs: [LeaderBoardScreen.LeaderBoardRowEntity.Config] {
        globalRowData.map { mock in
            .init(
                rank: mock.rank, name: mock.name, score: mock.score,
                avatarURL: nil,
                avatarColor: mock.isUser ? Color(hex: "#007AFF") : TapZeroDesign.Foreground.tertiary,
                isCurrentUser: mock.isUser, isDense: false
            )
        }
    }

    private var dailyRowConfigs: [LeaderBoardScreen.LeaderBoardRowEntity.Config] {
        dailyRowData.map { mock in
            .init(
                rank: mock.rank, name: mock.name, score: mock.score,
                avatarURL: nil,
                avatarColor: mock.isUser ? Color(hex: "#007AFF") : TapZeroDesign.Foreground.tertiary,
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

#Preview("1 Player — Ghost 2nd & 3rd") {
    LeaderBoardPreview(
        globalPodium: [("Burak", 920)],
        dailyPodium: [("Burak", 965)]
    )
}

#Preview("2 Players — Ghost 3rd") {
    LeaderBoardPreview(
        globalPodium: [("Mira Stone", 984), ("Burak", 920)],
        dailyPodium: [("Mira Stone", 965), ("Burak", 940)]
    )
}

#Preview("3 Players — Full Podium") {
    LeaderBoardPreview(
        globalPodium: [
            ("Mira Stone", 920), ("Kenji Park", 875), ("Yuna Choi", 812)
        ],
        dailyPodium: [
            ("Mira Stone", 965), ("Kenji Park", 940), ("Yuna Choi", 890)
        ]
    )
}

#Preview("4 Players — Podium + 1 Row") {
    LeaderBoardPreview(
        globalPodium: [
            ("Mira Stone", 984), ("Kenji Park", 971), ("Yuna Choi", 958)
        ],
        globalRows: [
            .init(rank: 4, name: "Burak", score: 891, isUser: true)
        ],
        dailyPodium: [
            ("Kenji Park", 998), ("Sofia Rossi", 994), ("Liam Carter", 987)
        ],
        dailyRows: [
            .init(rank: 4, name: "Burak", score: 942, isUser: true)
        ]
    )
}
