//
//  LockedOverlayConfig.swift
//  TapZero
//

import SwiftUI

extension LeaderBoardScreen.LockedOverlayEntity {
    struct Config: Equatable {
        let gamesPlayed: Int
        let gamesRequired: Int
        let gamesRemaining: Int
        let progress: CGFloat
    }
}
