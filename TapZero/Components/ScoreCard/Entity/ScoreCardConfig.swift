//
//  ScoreCardConfig.swift
//  TapZero
//

import SwiftUI

extension ScoreCardEntity {
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
        var cardBackground: Color?
        var userName: String?
        var profileImageURL: URL?
    }
}
