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

        // MARK: - String (format / computed)
        static var rankFirst: String { TextKey.localized("leaderBoard.rank.first") }
        static var rankSecond: String { TextKey.localized("leaderBoard.rank.second") }
        static var rankThird: String { TextKey.localized("leaderBoard.rank.third") }
        static var showingTop: String { TextKey.localized("leaderBoard.showingTop") }
        static var climbHint: String { TextKey.localized("leaderBoard.climbHint") }
        static var dailyResetsAt: String { TextKey.localized("leaderBoard.daily.resetsAt") }
        static var dailyTimeLeft: String { TextKey.localized("leaderBoard.daily.timeLeft") }
        static var lockedSubtitle: String { TextKey.localized("leaderBoard.locked.subtitle") }
        static var you: String { TextKey.localized("leaderBoard.you") }
    }
}
