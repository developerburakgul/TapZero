//
//  TextKey+History.swift
//  TapZero
//

import SwiftUI

extension TextKey {
    enum History {
        static let title: LocalizedStringKey = "history.title"

        // Tabs
        static let tabScores: LocalizedStringKey = "history.tab.scores"
        static let tabStats: LocalizedStringKey = "history.tab.stats"

        // Filter / Sort
        static let filterAll: LocalizedStringKey = "history.filter.all"
        static let sortNewest: LocalizedStringKey = "history.sort.newest"
        static let sortOldest: LocalizedStringKey = "history.sort.oldest"
        static let sortBest: LocalizedStringKey = "history.sort.best"
        static let sortWorst: LocalizedStringKey = "history.sort.worst"

        // Labels
        static let labelTarget: LocalizedStringKey = "history.label.target"
        static let labelYourTime: LocalizedStringKey = "history.label.yourTime"
        static let labelOffBy: LocalizedStringKey = "history.label.offBy"
        static let labelPerfect: LocalizedStringKey = "history.label.perfect"

        // Stats
        static let statAverageScore: LocalizedStringKey = "history.stat.averageScore"
        static let statBestRound: LocalizedStringKey = "history.stat.bestRound"
        static let statBestStreak: LocalizedStringKey = "history.stat.bestStreak"
        static let statPerfectRounds: LocalizedStringKey = "history.stat.perfectRounds"
        static let statAvgOffBy: LocalizedStringKey = "history.stat.avgOffBy"
        static let statDistribution: LocalizedStringKey = "history.stat.distribution"
        static let statTargetsPlayed: LocalizedStringKey = "history.stat.targetsPlayed"
        static let statStreak: LocalizedStringKey = "history.stat.streak"

        // KPI subtexts
        static func kpiBestRoundSub(_ date: String) -> LocalizedStringKey {
            "history.kpi.bestRound.sub \(date)"
        }

        static let kpiBestStreakSub: LocalizedStringKey = "history.kpi.bestStreak.sub"

        static func kpiPerfectSub(total: Int, percentage: String) -> LocalizedStringKey {
            "history.kpi.perfect.sub \(total) \(percentage)"
        }

        static let kpiAvgOffBySub: LocalizedStringKey = "history.kpi.avgOffBy.sub"

        // Hero stat
        static func heroAcrossGames(_ count: Int) -> LocalizedStringKey {
            "history.hero.acrossGames \(count)"
        }

        static let heroTrend: LocalizedStringKey = "history.hero.trend"

        static func heroTrendValue(arrow: String, percentage: String) -> LocalizedStringKey {
            "history.hero.trendValue \(arrow) \(percentage)"
        }

        // Distribution
        static let distributionByAccuracy: LocalizedStringKey = "history.distribution.byAccuracy"

        // Targets
        static let targetsTop5: LocalizedStringKey = "history.targets.top5"

        // Streak
        static let streakLast14Days: LocalizedStringKey = "history.streak.last14Days"

        static func streakDays(_ count: Int) -> LocalizedStringKey {
            "history.streak.days \(count)"
        }

        // Filter target option
        static func filterTargetOption(_ seconds: Int) -> LocalizedStringKey {
            "history.filter.targetOption \(seconds)"
        }

        // Empty state
        static let emptyTitle: LocalizedStringKey = "history.empty.title"
        static let emptySubtitle: LocalizedStringKey = "history.empty.subtitle"

        // Date labels
        static let dateToday: LocalizedStringKey = "history.date.today"
        static let dateYesterday: LocalizedStringKey = "history.date.yesterday"

        // Rating labels
        static let ratingPerfect: LocalizedStringKey = "history.rating.perfect"
        static let ratingGood: LocalizedStringKey = "history.rating.good"
        static let ratingMid: LocalizedStringKey = "history.rating.mid"
        static let ratingOff: LocalizedStringKey = "history.rating.off"

        // Chart axis
        static func chartGameNumber(_ number: Int) -> LocalizedStringKey {
            "history.chart.gameNumber \(number)"
        }

        static func chartYAxisLabel(_ value: Int) -> LocalizedStringKey {
            "history.chart.yAxisLabel \(value)"
        }

        // Chart average
        static func chartAvgLabel(_ value: Int) -> LocalizedStringKey {
            "history.chart.avgLabel \(value)"
        }

        // Chart pill
        static func chartPillScore(_ score: Int) -> LocalizedStringKey {
            "history.chart.pillScore \(score)"
        }

        static func chartPillGame(_ number: Int) -> LocalizedStringKey {
            "history.chart.pillGame \(number)"
        }

        // MARK: - String (computed)
        static var dateTodayStr: String { TextKey.localized("history.date.today") }
        static var dateYesterdayStr: String { TextKey.localized("history.date.yesterday") }

        // MARK: - String (format functions)
        static func rowTitle(target: Int, tapped: String) -> String {
            TextKey.localized("history.row.title \(target) \(tapped)")
        }

        static func rowOffset(sign: String, delta: String) -> String {
            TextKey.localized("history.row.offset \(sign) \(delta)")
        }

        static func rowDaysAgo(_ days: Int) -> String {
            TextKey.localized("history.row.daysAgo \(days)")
        }

        // Dynamic
        static func gameCount(_ count: Int) -> LocalizedStringKey {
            "history.gameCount \(count)"
        }

        static func targetFilter(_ seconds: Int) -> LocalizedStringKey {
            "history.targetFilter \(seconds)"
        }
    }
}
