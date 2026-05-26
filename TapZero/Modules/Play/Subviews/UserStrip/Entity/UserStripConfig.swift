//
//  UserStripConfig.swift
//  TapZero
//

import SwiftUI

extension PlayScreen.UserStripEntity {
    struct Config: Equatable {
        let initial: String
        let displayName: String
        let bestScore: Int?
        let avatarColor: Color

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.initial == rhs.initial
                && lhs.displayName == rhs.displayName
                && lhs.bestScore == rhs.bestScore
        }
    }
}
