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
        static let sortBest: LocalizedStringKey = "history.sort.best"

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

        // Dynamic
        static func gameCount(_ count: Int) -> LocalizedStringKey {
            "history.gameCount \(count)"
        }

        static func targetFilter(_ seconds: Int) -> LocalizedStringKey {
            "history.targetFilter \(seconds)"
        }
    }
}
