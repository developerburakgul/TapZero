//
//  HistoryScreen+Preview.swift
//  TapZero
//

import SwiftUI

// MARK: - Preview Helpers

private struct HistoryPreview: View {
    let games: [MockGame]
    @State private var selectedTab: HistoryViewModel.HistoryTab
    @State private var filterSortEntity: HistoryScreen.FilterSortEntity
    @State private var scoreChartBinding: HistoryScreen.ScoreChartEntity.Binding = .init()

    init(
        tab: HistoryViewModel.HistoryTab = .scores,
        games: [MockGame] = []
    ) {
        self.games = games
        _selectedTab = State(initialValue: tab)
        _filterSortEntity = State(initialValue: .init(
            binding: .init(),
            config: .init(availableTargets: Array(1...30))
        ))
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
}

// MARK: - Scores Page

extension HistoryPreview {
    @ViewBuilder
    private var scoresPage: some View {
        if games.isEmpty {
            ZStack {
                scoresBlurredPeek
                    .blur(radius: 8)
                    .opacity(0.55)
                    .disabled(true)

                HistoryScreen.EmptyOverlayView(
                    binding: .constant(.init()),
                    config: .init(
                        gamesPlayed: 0,
                        gamesRequired: 1,
                        gamesRemaining: 1,
                        progress: 0,
                        subtitle: TextKey.History.emptyOverlayScoresSubtitle(count: 1),
                        explanation: TextKey.History.emptyOverlayScoresExplanation
                    )
                ) { _ in }
            }
        } else {
            ScrollView {
                VStack(spacing: 0) {
                    HistoryScreen.ScoreChartView(
                        binding: $scoreChartBinding,
                        config: .init(
                            dataPoints: chartPoints,
                            isEmpty: false,
                            averageScore: mockAvgScore
                        )
                    )
                    HistoryScreen.FilterSortView(
                        binding: $filterSortEntity.binding,
                        config: filterSortEntity.config
                    ) { action in
                        switch action {
                        case .filterChanged(let target):
                            filterSortEntity.binding.selectedTarget = target
                        case .sortChanged(let order):
                            filterSortEntity.binding.sortOrder = order
                        }
                    }
                    scoreList
                }
            }
        }
    }

    private var scoresBlurredPeek: some View {
        ScrollView {
            VStack(spacing: 0) {
                HistoryScreen.ScoreChartView(
                    binding: .constant(.init()),
                    config: .init(
                        dataPoints: peekChartPoints,
                        isEmpty: false,
                        averageScore: peekAvgScore
                    )
                )
                HistoryScreen.FilterSortView(
                    binding: .constant(.init()),
                    config: .init(availableTargets: Array(1...30))
                ) { _ in }
                LazyVStack(spacing: 6) {
                    ForEach(peekRows) { row in
                        HistoryScreen.ScoreRowView(
                            binding: .constant(.init()),
                            config: row
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .scrollDisabled(true)
    }
}

// MARK: - Stats Page

extension HistoryPreview {
    @ViewBuilder
    private var statsPage: some View {
        if games.isEmpty {
            ZStack {
                statsBlurredPeek
                    .blur(radius: 8)
                    .opacity(0.55)
                    .disabled(true)

                HistoryScreen.EmptyOverlayView(
                    binding: .constant(.init()),
                    config: .init(
                        gamesPlayed: 0,
                        gamesRequired: 1,
                        gamesRemaining: 1,
                        progress: 0,
                        subtitle: TextKey.History.emptyOverlayStatsSubtitle(count: 1),
                        explanation: TextKey.History.emptyOverlayStatsExplanation
                    )
                ) { _ in }
            }
        } else {
            ScrollView { statsContent }
        }
    }

    private var statsBlurredPeek: some View {
        ScrollView {
            VStack(spacing: 16) {
                HistoryScreen.HeroStatView(
                    binding: .constant(.init()),
                    config: .init(
                        averageScore: 724,
                        totalGames: 42,
                        trendPercentage: 12,
                        trendIsPositive: true
                    )
                )
                HistoryScreen.KPIGridView(
                    binding: .constant(.init()),
                    config: .init(
                        bestRoundScore: 986, bestRoundDate: "2 days ago",
                        bestStreak: 7, perfectCount: 12,
                        totalGames: 42, perfectPercentage: 29,
                        avgOffBy: "0.18s"
                    )
                )
                HistoryScreen.DistributionView(
                    binding: .constant(.init()),
                    config: .init(segments: mockDistribution)
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .scrollDisabled(true)
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
}

// MARK: - Score List

extension HistoryPreview {
    private var scoreList: some View {
        LazyVStack(spacing: 6) {
            ForEach(mockRows) { row in
                HistoryScreen.ScoreRowView(
                    binding: .constant(.init()),
                    config: row
                )
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Mock Builders

extension HistoryPreview {
    private var chartPoints: [HistoryScreen.ScoreChartEntity.ChartDataPoint] {
        games.enumerated().map { index, game in
            .init(id: index + 1, score: game.score, rating: game.rating)
        }
    }

    private var mockAvgScore: Int {
        guard !games.isEmpty else { return 0 }
        return games.map(\.score).reduce(0, +) / games.count
    }

    private var filteredSortedGames: [MockGame] {
        var result = games

        if let target = filterSortEntity.binding.selectedTarget {
            result = result.filter { $0.target == target }
        }

        switch filterSortEntity.binding.sortOrder {
        case .newest:
            break // default order
        case .oldest:
            result = result.reversed()
        case .best:
            result.sort { $0.score > $1.score }
        case .worst:
            result.sort { $0.score < $1.score }
        }

        return result
    }

    private var mockRows: [HistoryScreen.ScoreRowEntity.Config] {
        filteredSortedGames.enumerated().map { index, game in
            let sign = game.tapped >= Double(game.target) ? "+" : "−"
            let tapped = String(format: "%.2f", game.tapped)
            let delta = String(format: "%.2f", game.delta)
            return .init(
                id: "\(index)",
                score: game.score,
                targetSeconds: game.target,
                tappedSeconds: game.tapped,
                delta: game.delta,
                rating: game.rating,
                discColor: discColor(game.rating),
                discSoftBackground: rowBg(game.rating),
                dateFormatted: "\(game.target)s · \(tapped)s",
                subtitleFormatted: "\(game.time) · \(sign)\(delta)s"
            )
        }
    }
}

// MARK: - Peek Mock Data (blurred background for empty states)

extension HistoryPreview {
    private var peekChartPoints: [HistoryScreen.ScoreChartEntity.ChartDataPoint] {
        peekGames.enumerated().map { index, game in
            .init(id: index + 1, score: game.score, rating: game.rating)
        }
    }

    private var peekAvgScore: Int {
        let scores = peekGames.map(\.score)
        return scores.reduce(0, +) / scores.count
    }

    private var peekRows: [HistoryScreen.ScoreRowEntity.Config] {
        peekGames.prefix(6).enumerated().map { index, game in
            let sign = game.tapped >= Double(game.target) ? "+" : "−"
            let tapped = String(format: "%.2f", game.tapped)
            let delta = String(format: "%.2f", game.delta)
            return .init(
                id: "peek-\(index)",
                score: game.score,
                targetSeconds: game.target,
                tappedSeconds: game.tapped,
                delta: game.delta,
                rating: game.rating,
                discColor: discColor(game.rating),
                discSoftBackground: rowBg(game.rating),
                dateFormatted: "\(game.target)s · \(tapped)s",
                subtitleFormatted: "Today · \(sign)\(delta)s"
            )
        }
    }

    private var peekGames: [MockGame] { fullGames }
}

// MARK: - Color Helpers

extension HistoryPreview {
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
}

// MARK: - Stats Mock Data

extension HistoryPreview {
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
    .init(score: 998, target: 10, tapped: 10.01, delta: 0.01, rating: .perfect, time: "Today"),
    .init(score: 870, target: 15, tapped: 14.78, delta: 0.22, rating: .good, time: "Today"),
    .init(score: 935, target: 5, tapped: 4.93, delta: 0.07, rating: .good, time: "Today"),
    .init(score: 720, target: 10, tapped: 9.45, delta: 0.55, rating: .mid, time: "Yesterday"),
    .init(score: 640, target: 20, tapped: 18.5, delta: 1.5, rating: .bad, time: "Yesterday"),
    .init(score: 950, target: 5, tapped: 5.05, delta: 0.05, rating: .good, time: "Yesterday"),
    .init(score: 995, target: 10, tapped: 9.99, delta: 0.01, rating: .perfect, time: "Yesterday"),
    .init(score: 810, target: 15, tapped: 14.62, delta: 0.38, rating: .mid, time: "Yesterday"),
    .init(score: 890, target: 10, tapped: 10.15, delta: 0.15, rating: .good, time: "Yesterday"),
    .init(score: 960, target: 5, tapped: 5.04, delta: 0.04, rating: .good, time: "Yesterday")
]

// MARK: - Screen Previews

#Preview("Full — Scores Tab") {
    HistoryPreview(tab: .scores, games: fullGames)
}

#Preview("Full — Stats Tab") {
    HistoryPreview(tab: .stats, games: fullGames)
}

#Preview("Empty — Scores") {
    HistoryPreview(tab: .scores, games: [])
}

#Preview("Empty — Stats") {
    HistoryPreview(tab: .stats, games: [])
}

#Preview("Single Game") {
    HistoryPreview(
        tab: .scores,
        games: [
            .init(score: 870, target: 10, tapped: 10.18, delta: 0.18, rating: .good, time: "Today")
        ]
    )
}
