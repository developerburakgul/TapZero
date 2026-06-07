//
//  EmptyOverlayConfig.swift
//  TapZero
//

import SwiftUI

extension HistoryScreen.EmptyOverlayEntity {
    struct Config: Equatable {
        let gamesPlayed: Int
        let gamesRequired: Int
        let gamesRemaining: Int
        let progress: CGFloat
        let subtitle: LocalizedStringKey
        let explanation: LocalizedStringKey

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.gamesPlayed == rhs.gamesPlayed
                && lhs.gamesRequired == rhs.gamesRequired
                && lhs.gamesRemaining == rhs.gamesRemaining
                && lhs.progress == rhs.progress
        }
    }
}
