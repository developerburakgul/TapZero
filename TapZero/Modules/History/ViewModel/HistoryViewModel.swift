//
//  HistoryViewModel.swift
//  TapZero
//

import Combine
import SwiftfulRouting
import SwiftUI

@MainActor
final class HistoryViewModel: ObservableObject {
    // MARK: - Non-Published Properties
    var didAppearOnce: Bool = false
    let router: Router
    let entity: HistoryEntity

    // MARK: - Managers
    @Injected private(set) var eventManager: EventManager
    @ObservedInjected private(set) var gameManager: GameManager
    @ObservedInjected private(set) var userManager: UserManager
    @Injected private(set) var crashReporter: CrashReporterProtocol
    @Injected private(set) var deepLinkManager: DeepLinkManager

    // MARK: - Published Properties
    @Published var selectedTab: HistoryTab = .scores
    @Published var isLoading: Bool = false

    // MARK: - Subview Entities
    @Published var headerEntity: HistoryScreen.HistoryHeaderEntity = .init(
        binding: .init(),
        config: .init(selectedTab: .scores)
    )
    @Published var scoreChartEntity: HistoryScreen.ScoreChartEntity = .init(
        binding: .init(),
        config: .init(dataPoints: [], isEmpty: true, averageScore: 0)
    )
    @Published var filterSortEntity: HistoryScreen.FilterSortEntity = .init(
        binding: .init(),
        config: .init(availableTargets: [])
    )
    @Published var heroStatEntity: HistoryScreen.HeroStatEntity = .init(
        binding: .init(),
        config: .init(averageScore: 0, totalGames: 0, trendPercentage: nil, trendIsPositive: true)
    )
    @Published var kpiGridEntity: HistoryScreen.KPIGridEntity = .init(
        binding: .init(),
        config: .init(
            bestRoundScore: 0, bestRoundDate: "", bestStreak: 0,
            perfectCount: 0, totalGames: 0, perfectPercentage: 0, avgOffBy: "0.00s"
        )
    )
    @Published var distributionEntity: HistoryScreen.DistributionEntity = .init(
        binding: .init(),
        config: .init(segments: [])
    )
    @Published var targetsPlayedEntity: HistoryScreen.TargetsPlayedEntity = .init(
        binding: .init(),
        config: .init(targets: [])
    )
    @Published var streakHeatmapEntity: HistoryScreen.StreakHeatmapEntity = .init(
        binding: .init(),
        config: .init(days: [], currentStreak: 0, maxGamesInDay: 0)
    )
    @Published var emptyOverlayEntity: HistoryScreen.EmptyOverlayEntity = .init(
        binding: .init(),
        config: .init(gamesPlayed: 0, gamesRequired: 1, gamesRemaining: 1, progress: 0, subtitle: "")
    )

    // MARK: - Init
    init(
        router: Router,
        entity: HistoryEntity
    ) {
        self.router = router
        self.entity = entity
    }
}

// MARK: - Tab Enum
extension HistoryViewModel {
    enum HistoryTab: Int, CaseIterable {
        case scores, stats
    }
}

// MARK: - Computed Properties
extension HistoryViewModel {
    // MARK: - Data
    var gameHistory: [GameModel] { gameManager.gameHistory }
    var userStats: UserStatsModel? { gameManager.userStats }
    var currentUserId: String? { userManager.currentUser?.userId }
    var isEmpty: Bool { gameHistory.isEmpty }

    // MARK: - Empty Overlay
    var unlockRequiredGames: Int { 1 }
    var gamesPlayed: Int { userStats?.totalGamesPlayed ?? 0 }
    var gamesRemaining: Int { max(0, unlockRequiredGames - gamesPlayed) }
    var unlockProgress: CGFloat { CGFloat(gamesPlayed) / CGFloat(unlockRequiredGames) }

    // MARK: - Filtered & Sorted Games
    var filteredGames: [GameModel] {
        var games = gameHistory

        if let target = filterSortEntity.binding.selectedTarget {
            games = games.filter { $0.targetSeconds == target }
        }

        switch filterSortEntity.binding.sortOrder {
        case .newest:
            games.sort { $0.playedAt > $1.playedAt }
        case .oldest:
            games.sort { $0.playedAt < $1.playedAt }
        case .best:
            games.sort { $0.score > $1.score }
        case .worst:
            games.sort { $0.score < $1.score }
        }

        return games
    }

    // MARK: - Available Targets
    var availableTargets: [Int] {
        Array(Set(gameHistory.map(\.targetSeconds))).sorted()
    }

    // MARK: - Chart Data
    var chartDataPoints: [HistoryScreen.ScoreChartEntity.ChartDataPoint] {
        let sorted = gameHistory.sorted { $0.playedAt < $1.playedAt }

        return sorted.enumerated().map { index, game in
            .init(id: index + 1, score: game.score, rating: game.performanceRating)
        }
    }

    // MARK: - Score Rows
    var scoreRows: [HistoryScreen.ScoreRowEntity.Config] {
        filteredGames.map { makeRowConfig(from: $0) }
    }

    private func makeRowConfig(from game: GameModel) -> HistoryScreen.ScoreRowEntity.Config {
        let tappedFormatted = String(format: "%.2f", game.tappedSeconds)
        let title = TextKey.History.rowTitle(target: game.targetSeconds, tapped: tappedFormatted)

        let sign = game.tappedSeconds >= Double(game.targetSeconds) ? "+" : "−"
        let deltaFormatted = String(format: "%.2f", game.delta)
        let relDate = relativeDate(for: game.playedAt)
        let offset = TextKey.History.rowOffset(sign: sign, delta: deltaFormatted)
        let subtitle = "\(relDate) · \(offset)"

        return HistoryScreen.ScoreRowEntity.Config(
            id: game.gameId,
            score: game.score,
            targetSeconds: game.targetSeconds,
            tappedSeconds: game.tappedSeconds,
            delta: game.delta,
            rating: game.performanceRating,
            discColor: discColor(for: game.performanceRating),
            discSoftBackground: discSoftBackground(for: game.performanceRating),
            dateFormatted: title,
            subtitleFormatted: subtitle
        )
    }

    // MARK: - Stats Computations
    var averageScore: Int {
        guard !gameHistory.isEmpty else { return 0 }
        return gameHistory.map(\.score).reduce(0, +) / gameHistory.count
    }

    var trendPercentage: Double? {
        let sorted = gameHistory.sorted { $0.playedAt < $1.playedAt }
        guard sorted.count >= 10 else { return nil }

        let midIndex = sorted.count / 2
        let olderHalf = Array(sorted.prefix(midIndex))
        let recentHalf = Array(sorted.suffix(from: midIndex))

        let olderAvg = Double(olderHalf.map(\.score).reduce(0, +)) / Double(olderHalf.count)
        let recentAvg = Double(recentHalf.map(\.score).reduce(0, +)) / Double(recentHalf.count)

        guard olderAvg > 0 else { return nil }
        return ((recentAvg - olderAvg) / olderAvg) * 100
    }

    var bestStreak: Int {
        let sorted = gameHistory.sorted { $0.playedAt < $1.playedAt }
        var maxStreak = 0
        var currentStreak = 0

        for game in sorted {
            let rating = game.performanceRating
            if rating == .perfect || rating == .good {
                currentStreak += 1
                maxStreak = max(maxStreak, currentStreak)
            } else {
                currentStreak = 0
            }
        }
        return maxStreak
    }

    var perfectCount: Int {
        gameHistory.filter { $0.performanceRating == .perfect }.count
    }

    var perfectPercentage: Double {
        guard !gameHistory.isEmpty else { return 0 }
        return Double(perfectCount) / Double(gameHistory.count) * 100
    }

    var avgDelta: Double {
        guard !gameHistory.isEmpty else { return 0 }
        return gameHistory.map(\.delta).reduce(0, +) / Double(gameHistory.count)
    }

    var bestRound: GameModel? {
        gameHistory.max { $0.score < $1.score }
    }

    // MARK: - Rating Distribution
    var ratingDistribution: [HistoryScreen.DistributionEntity.DistributionSegment] {
        let total = gameHistory.count
        guard total > 0 else { return [] }

        return PerformanceRating.allCases.compactMap { rating in
            let count = gameHistory.filter { $0.performanceRating == rating }.count
            guard count > 0 else { return nil }
            return HistoryScreen.DistributionEntity.DistributionSegment(
                id: rating.rawValue,
                rating: rating,
                count: count,
                percentage: Double(count) / Double(total) * 100,
                color: discColor(for: rating)
            )
        }
    }

    // MARK: - Targets Stats
    var targetStats: [HistoryScreen.TargetsPlayedEntity.TargetStat] {
        let grouped = Dictionary(grouping: gameHistory, by: \.targetSeconds)
        let sorted = grouped.sorted { $0.value.count > $1.value.count }
        let topTargets = Array(sorted.prefix(5))
        let maxCount = topTargets.first?.value.count ?? 1

        return topTargets.map { target, games in
            HistoryScreen.TargetsPlayedEntity.TargetStat(
                id: target,
                targetLabel: "\(target)s",
                playCount: games.count,
                bestScore: games.map(\.score).max() ?? 0,
                barFraction: Double(games.count) / Double(maxCount)
            )
        }
    }

    // MARK: - Heatmap
    var heatmapDays: [HistoryScreen.StreakHeatmapEntity.HeatmapDay] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        return (0..<14).reversed().compactMap { daysAgo in
            guard let date = calendar.date(byAdding: .day, value: -daysAgo, to: today) else { return nil }
            let count = gameHistory.filter { calendar.isDate($0.playedAt, inSameDayAs: date) }.count

            return HistoryScreen.StreakHeatmapEntity.HeatmapDay(
                id: formatter.string(from: date),
                dayLabel: weekdaySymbol(for: date, calendar: calendar),
                gamesPlayed: count
            )
        }
    }

    var heatmapMaxGames: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<14).compactMap { daysAgo in
            guard let date = calendar.date(byAdding: .day, value: -daysAgo, to: today) else { return nil }
            return gameHistory.filter { calendar.isDate($0.playedAt, inSameDayAs: date) }.count
        }.max() ?? 0
    }

    var currentStreak: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var streak = 0
        for daysAgo in 0..<14 {
            guard let date = calendar.date(byAdding: .day, value: -daysAgo, to: today) else { break }
            let count = gameHistory.filter { calendar.isDate($0.playedAt, inSameDayAs: date) }.count
            if count > 0 {
                streak += 1
            } else {
                break
            }
        }
        return streak
    }

    // MARK: - Helpers
    func discColor(for rating: PerformanceRating) -> Color {
        switch rating {
        case .perfect: TapZeroDesign.History.perfectDisc
        case .good: TapZeroDesign.History.goodDisc
        case .mid: TapZeroDesign.History.midDisc
        case .bad: TapZeroDesign.History.badDisc
        }
    }

    func discSoftBackground(for rating: PerformanceRating) -> Color {
        switch rating {
        case .perfect, .good: TapZeroDesign.Score.goodBackground
        case .mid: TapZeroDesign.Score.neutralBackground
        case .bad: TapZeroDesign.Score.badBackground
        }
    }

    private func relativeDate(for date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return TextKey.History.dateTodayStr
        } else if calendar.isDateInYesterday(date) {
            return TextKey.History.dateYesterdayStr
        } else {
            let days = calendar.dateComponents([.day], from: date, to: Date()).day ?? 0
            if days <= 6 {
                return TextKey.History.rowDaysAgo(days)
            } else {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                return formatter.string(from: date)
            }
        }
    }

    private func weekdaySymbol(for date: Date, calendar: Calendar) -> String {
        let weekday = calendar.component(.weekday, from: date)
        let symbols = ["S", "M", "T", "W", "T", "F", "S"]
        return symbols[weekday - 1]
    }
}
