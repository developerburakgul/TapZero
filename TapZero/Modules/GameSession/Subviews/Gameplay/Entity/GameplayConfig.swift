//
//  GameplayConfig.swift
//  TapZero
//

import SwiftUI

extension GameSessionScreen.GameplayEntity {
    struct Config: Equatable {
        let targetTimeFormatted: String
        let tapPosition: CGPoint?
        let showRipple: Bool
    }
}
