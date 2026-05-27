//
//  TextKey+LeaderBoard.swift
//  TapZero
//

import SwiftUI

extension TextKey {
    enum LeaderBoard {
        // MARK: - LocalizedStringKey (SwiftUI Text)
        static let title: LocalizedStringKey = "leaderBoard.title"
        static let tabGlobal: LocalizedStringKey = "leaderBoard.tab.global"
        static let tabDaily: LocalizedStringKey = "leaderBoard.tab.daily"
        static let yourRanking: LocalizedStringKey = "leaderBoard.yourRanking"
        static let lockedTitle: LocalizedStringKey = "leaderBoard.locked.title"
        static let lockedWhyTitle: LocalizedStringKey = "leaderBoard.locked.whyTitle"
        static let lockedWhyBody: LocalizedStringKey = "leaderBoard.locked.whyBody"
        static let lockedCta: LocalizedStringKey = "leaderBoard.locked.cta"

        // MARK: - String (computed)
        static var rankFirst: String { TextKey.localized("leaderBoard.rank.first") }
        static var rankSecond: String { TextKey.localized("leaderBoard.rank.second") }
        static var rankThird: String { TextKey.localized("leaderBoard.rank.third") }
        static var dailyResetsAt: String { TextKey.localized("leaderBoard.daily.resetsAt") }
        static var you: String { TextKey.localized("leaderBoard.you") }

        // MARK: - String (format functions)
        static func lockedSubtitle(count: Int) -> String {
            TextKey.localized("leaderBoard.locked.subtitle \(count)")
        }

        static func showingTop(count: Int) -> String {
            TextKey.localized("leaderBoard.showingTop \(count)")
        }

        static func climbHint(climb: Int, limit: Int) -> String {
            TextKey.localized("leaderBoard.climbHint \(climb) \(limit)")
        }

        static func dailyTimeLeft(hours: Int, minutes: Int) -> String {
            TextKey.localized("leaderBoard.daily.timeLeft \(hours) \(minutes)")
        }

        static func lockedProgress(played: Int, required: Int) -> String {
            TextKey.localized("leaderBoard.locked.progress \(played) \(required)")
        }
    }
}
