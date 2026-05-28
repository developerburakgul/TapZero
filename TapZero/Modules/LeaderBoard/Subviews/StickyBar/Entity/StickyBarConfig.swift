//
//  StickyBarConfig.swift
//  TapZero
//

import SwiftUI

extension LeaderBoardScreen.StickyBarEntity {
    struct Config: Equatable {
        let rank: Int
        let score: Int
        let name: String
        let avatarURL: String?
        let avatarColor: Color
        let climbCount: Int
        let listLimit: Int
    }
}
