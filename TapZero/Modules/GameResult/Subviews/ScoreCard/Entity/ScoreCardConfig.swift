//
//  ScoreCardConfig.swift
//  TapZero
//

import SwiftUI

extension GameResultScreen.ScoreCardEntity {
    struct Config: Equatable {
        let score: Int
        let scoreColor: Color
        let offLabelText: String
        let offPillBackground: Color
        let isPerfect: Bool
        let targetTimeFormatted: String
        let tappedTimeFormatted: String
        let timelineUserOffset: CGFloat
        let targetSeconds: Int
    }
}
