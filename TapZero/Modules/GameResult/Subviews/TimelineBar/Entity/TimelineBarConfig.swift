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
        var foregroundOverride: Color?
        var hairlineOverride: Color?
        var targetDotFillOverride: Color?
    }
}
