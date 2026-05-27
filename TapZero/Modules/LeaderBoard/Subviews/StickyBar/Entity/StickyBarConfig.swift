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
        let colorHex: String?
        let climbCount: Int
        let listLimit: Int
    }
}
