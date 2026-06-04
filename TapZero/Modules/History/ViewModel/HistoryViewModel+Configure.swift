//
//  HistoryViewModel+Configure.swift
//  TapZero
//

import Foundation

// MARK: - Configure
extension HistoryViewModel {
    func configure() {
        configureHeader()
        configureScoreChart()
        configureFilterSort()
        configureHeroStat()
        configureKPIGrid()
        configureDistribution()
        configureTargetsPlayed()
        configureStreakHeatmap()
        configureEmptyOverlay()
    }

    private func configureHeader() {
        headerEntity.config = .init(selectedTab: selectedTab)
    }

    private func configureScoreChart() {
        scoreChartEntity.config = .init(
            dataPoints: chartDataPoints,
            isEmpty: gameHistory.isEmpty,
            averageScore: averageScore
        )
    }

    private func configureFilterSort() {
        filterSortEntity.config = .init(
            availableTargets: Array(1...30)
        )
    }

    private func configureHeroStat() {
        let trend = trendPercentage
        heroStatEntity.config = .init(
            averageScore: averageScore,
            totalGames: gameHistory.count,
            trendPercentage: trend,
            trendIsPositive: (trend ?? 0) >= 0
        )
    }

    private func configureKPIGrid() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        let bestDate = bestRound.map { dateFormatter.string(from: $0.playedAt) } ?? ""

        kpiGridEntity.config = .init(
            bestRoundScore: bestRound?.score ?? 0,
            bestRoundDate: bestDate,
            bestStreak: bestStreak,
            perfectCount: perfectCount,
            totalGames: gameHistory.count,
            perfectPercentage: perfectPercentage,
            avgOffBy: String(format: "%.2fs", avgDelta)
        )
    }

    private func configureDistribution() {
        distributionEntity.config = .init(segments: ratingDistribution)
    }

    private func configureTargetsPlayed() {
        targetsPlayedEntity.config = .init(targets: targetStats)
    }

    private func configureStreakHeatmap() {
        streakHeatmapEntity.config = .init(
            days: heatmapDays,
            currentStreak: currentStreak,
            maxGamesInDay: heatmapMaxGames
        )
    }

    private func configureEmptyOverlay() {
        let subtitle: LocalizedStringKey = selectedTab == .scores
            ? TextKey.History.emptyOverlayScoresSubtitle(count: gamesRemaining)
            : TextKey.History.emptyOverlayStatsSubtitle(count: gamesRemaining)

        emptyOverlayEntity.config = .init(
            gamesPlayed: gamesPlayed,
            gamesRequired: unlockRequiredGames,
            gamesRemaining: gamesRemaining,
            progress: unlockProgress,
            subtitle: subtitle
        )
    }
}
