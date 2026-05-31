//
//  HistoryScreen+Preview.swift
//  TapZero
//

import SwiftUI

// MARK: - Preview Helpers

private struct HistoryPreview: View {
    let games: [MockGame]
    @State private var selectedTab: HistoryViewModel.HistoryTab

    init(
        tab: HistoryViewModel.HistoryTab = .scores,
        games: [MockGame] = []
    ) {
        self.games = games
        _selectedTab = State(initialValue: tab)
    }

    var body: some View {
        ZStack {
            TapZeroDesign.Background.primary.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                tabPages
            }
        }
    }

    private var header: some View {
        HistoryScreen.HistoryHeaderView(
            binding: .constant(.init(selectedTab: selectedTab)),
            config: .init(selectedTab: selectedTab)
        )
    }

    private var tabPages: some View {
        TabView(selection: $selectedTab) {
            scoresPage.tag(HistoryViewModel.HistoryTab.scores)
            statsPage.tag(HistoryViewModel.HistoryTab.stats)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(.easeInOut(duration: 0.25), value: selectedTab)
    }

    // MARK: - Scores Page

    @ViewBuilder
    private var scoresPage: some View {
        if games.isEmpty {
            emptyView
        } else {
            ScrollView {
                VStack(spacing: 0) {
                    HistoryScreen.ScoreChartView(
                        binding: .constant(.init()),
                        config: .init(dataPoints: chartPoints, isEmpty: false)
                    )
                    HistoryScreen.FilterSortView(
                        binding: .constant(.init()),
                        config: .init(
                            availableTargets: mockTargets,
                            gameCount: games.count
                        )
                    )
                    daySections
                }
            }
        }
    }

    // MARK: - Stats Page

    @ViewBuilder
    private var statsPage: some View {
        if games.isEmpty {
            emptyView
        } else {
            ScrollView {
                statsContent
            }
        }
    }

    private var statsContent: some View {
        VStack(spacing: 16) {
            HistoryScreen.HeroStatView(
                binding: .constant(.init()),
                config: .init(
                    averageScore: mockAvgScore,
                    totalGames: games.count,
                    trendPercentage: 12,
                    trendIsPositive: true
                )
            )
            HistoryScreen.KPIGridView(
                binding: .constant(.init()),
                config: .init(
                    bestRoundScore: 912, bestRoundDate: "2 days ago",
                    bestStreak: 18, perfectCount: 23,
                    totalGames: 60, perfectPercentage: 38,
                    avgOffBy: "0.34s"
                )
            )
            HistoryScreen.DistributionView(
                binding: .constant(.init()),
                config: .init(segments: mockDistribution)
            )
            HistoryScreen.TargetsPlayedView(
                binding: .constant(.init()),
                config: .init(targets: mockTargetStats)
            )
            HistoryScreen.StreakHeatmapView(
                binding: .constant(.init()),
                config: .init(days: mockHeatmap, currentStreak: 7, maxGamesInDay: 6)
            )
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }

    private var emptyView: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 48))
                .foregroundStyle(TapZeroDesign.Foreground.tertiary)
            Text(TextKey.History.emptyTitle)
                .font(TapZeroTypography.Heading.h3)
                .foregroundStyle(TapZeroDesign.Foreground.primary)
            Text(TextKey.History.emptySubtitle)
                .font(TapZeroTypography.Body.medium)
                .foregroundStyle(TapZeroDesign.Foreground.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Day Sections

    private var daySections: some View {
        LazyVStack(spacing: 0) {
            ForEach(mockDaySections) { section in
                HistoryScreen.DaySectionView(
                    binding: .constant(.init()),
                    config: section
                )
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Mock Builders

    private var chartPoints: [HistoryScreen.ScoreChartEntity.ChartDataPoint] {
        games.enumerated().map { index, game in
            .init(id: index + 1, score: game.score, rating: game.rating)
        }
    }

    private var mockTargets: [Int] {
        Array(Set(games.map(\.target))).sorted()
    }

    private var mockAvgScore: Int {
        guard !games.isEmpty else { return 0 }
        return games.map(\.score).reduce(0, +) / games.count
    }

    private var mockDaySections: [HistoryScreen.DaySectionEntity.Config] {
        let todayRows = Array(mockRows.prefix(3))
        let yesterdayRows = Array(mockRows.dropFirst(3))
        return [
            .init(id: "today", dateLabel: "Today", gameCount: todayRows.count, rows: todayRows),
            .init(id: "yesterday", dateLabel: "Yesterday", gameCount: yesterdayRows.count, rows: yesterdayRows)
        ]
    }

    private var mockRows: [HistoryScreen.ScoreRowEntity.Config] {
        games.enumerated().map { index, game in
            let sign = game.tapped >= Double(game.target) ? "+" : "−"
            return .init(
                id: "\(index)",
                score: game.score,
                targetSeconds: game.target,
                tappedSeconds: game.tapped,
                delta: game.delta,
                rating: game.rating,
                discColor: discColor(game.rating),
                discSoftBackground: rowBg(game.rating),
                dateFormatted: game.time,
                subtitleFormatted: mockSubtitle(game: game, sign: sign)
            )
        }
    }

    private func mockSubtitle(game: MockGame, sign: String) -> String {
        let tapped = String(format: "%.2f", game.tapped)
        let delta = String(format: "%.2f", game.delta)
        return "\(game.target)s · \(tapped)s · \(sign)\(delta)s"
    }

    private func discColor(_ rating: PerformanceRating) -> Color {
        switch rating {
        case .perfect: TapZeroDesign.History.perfectDisc
        case .good: TapZeroDesign.History.goodDisc
        case .mid: TapZeroDesign.History.midDisc
        case .bad: TapZeroDesign.History.badDisc
        }
    }

    private func rowBg(_ rating: PerformanceRating) -> Color {
        switch rating {
        case .perfect, .good: TapZeroDesign.Score.goodBackground
        case .mid: TapZeroDesign.Score.neutralBackground
        case .bad: TapZeroDesign.Score.badBackground
        }
    }

    private var mockDistribution: [HistoryScreen.DistributionEntity.DistributionSegment] {
        [
            .init(id: "perfect", rating: .perfect, count: 5, percentage: 25, color: TapZeroDesign.History.perfectDisc),
            .init(id: "good", rating: .good, count: 8, percentage: 40, color: TapZeroDesign.History.goodDisc),
            .init(id: "mid", rating: .mid, count: 4, percentage: 20, color: TapZeroDesign.History.midDisc),
            .init(id: "bad", rating: .bad, count: 3, percentage: 15, color: TapZeroDesign.History.badDisc)
        ]
    }

    private var mockTargetStats: [HistoryScreen.TargetsPlayedEntity.TargetStat] {
        [
            .init(id: 10, targetLabel: "10s", playCount: 8, bestScore: 998, barFraction: 1.0),
            .init(id: 5, targetLabel: "5s", playCount: 6, bestScore: 985, barFraction: 0.75),
            .init(id: 15, targetLabel: "15s", playCount: 4, bestScore: 970, barFraction: 0.5),
            .init(id: 20, targetLabel: "20s", playCount: 2, bestScore: 920, barFraction: 0.25)
        ]
    }

    private var mockHeatmap: [HistoryScreen.StreakHeatmapEntity.HeatmapDay] {
        [
            .init(id: "d0", dayLabel: "M", gamesPlayed: 0),
            .init(id: "d1", dayLabel: "T", gamesPlayed: 2),
            .init(id: "d2", dayLabel: "W", gamesPlayed: 5),
            .init(id: "d3", dayLabel: "T", gamesPlayed: 3),
            .init(id: "d4", dayLabel: "F", gamesPlayed: 0),
            .init(id: "d5", dayLabel: "S", gamesPlayed: 1),
            .init(id: "d6", dayLabel: "S", gamesPlayed: 4),
            .init(id: "d7", dayLabel: "M", gamesPlayed: 6),
            .init(id: "d8", dayLabel: "T", gamesPlayed: 0),
            .init(id: "d9", dayLabel: "W", gamesPlayed: 1),
            .init(id: "d10", dayLabel: "T", gamesPlayed: 0),
            .init(id: "d11", dayLabel: "F", gamesPlayed: 2),
            .init(id: "d12", dayLabel: "S", gamesPlayed: 3),
            .init(id: "d13", dayLabel: "S", gamesPlayed: 0)
        ]
    }
}

// MARK: - Mock Data

private struct MockGame {
    let score: Int
    let target: Int
    let tapped: Double
    let delta: Double
    let rating: PerformanceRating
    let time: String
}

private let fullGames: [MockGame] = [
    .init(score: 998, target: 10, tapped: 10.01, delta: 0.01, rating: .perfect, time: "2:34 PM"),
    .init(score: 870, target: 15, tapped: 14.78, delta: 0.22, rating: .good, time: "2:20 PM"),
    .init(score: 935, target: 5, tapped: 4.93, delta: 0.07, rating: .good, time: "2:05 PM"),
    .init(score: 720, target: 10, tapped: 9.45, delta: 0.55, rating: .mid, time: "11:30 AM"),
    .init(score: 640, target: 20, tapped: 18.5, delta: 1.5, rating: .bad, time: "11:15 AM"),
    .init(score: 950, target: 5, tapped: 5.05, delta: 0.05, rating: .good, time: "10:45 AM"),
    .init(score: 995, target: 10, tapped: 9.99, delta: 0.01, rating: .perfect, time: "10:30 AM"),
    .init(score: 810, target: 15, tapped: 14.62, delta: 0.38, rating: .mid, time: "9:00 AM"),
    .init(score: 890, target: 10, tapped: 10.15, delta: 0.15, rating: .good, time: "8:45 AM"),
    .init(score: 960, target: 5, tapped: 5.04, delta: 0.04, rating: .good, time: "8:30 AM")
]

// MARK: - Screen Previews

#Preview("Full — Scores Tab") {
    HistoryPreview(tab: .scores, games: fullGames)
}

#Preview("Full — Stats Tab") {
    HistoryPreview(tab: .stats, games: fullGames)
}

#Preview("Empty — No Games") {
    HistoryPreview(tab: .scores, games: [])
}

#Preview("Single Game") {
    HistoryPreview(
        tab: .scores,
        games: [
            .init(score: 870, target: 10, tapped: 10.18, delta: 0.18, rating: .good, time: "3:00 PM")
        ]
    )
}
