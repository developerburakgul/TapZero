//
//  TimelineBarConfig.swift
//  TapZero
//

import SwiftUI

extension GameResultScreen.TimelineBarEntity {
    struct Config: Equatable {
        let userOffset: CGFloat
        let scoreColor: Color
        let isPerfect: Bool
        let targetLabel: String
    }
}
