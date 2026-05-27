//
//  GameSession+Constants.swift
//  TapZero
//

import SwiftUI

extension GameSessionScreen {
    struct Constants {
        // Countdown
        let outerRingSize: CGFloat = 320
        let innerRingSize: CGFloat = 220
        let ringStrokeWidth: CGFloat = 1.5
        let outerRingOpacity: Double = 0.22
        let innerRingOpacity: Double = 0.14
        let countdownTracking: CGFloat = -10
        let goTracking: CGFloat = 8
        let countdownStepDuration: Duration = .seconds(1)
        let goDisplayDuration: Duration = .milliseconds(400)

        // Gameplay
        let targetTopPadding: CGFloat = 58
        let targetLabelTracking: CGFloat = 1.8
        let targetValueTracking: CGFloat = -1
        let targetValueSize: CGFloat = 34
        let hintBottomPadding: CGFloat = 50
        let hintTracking: CGFloat = 0.5

        // Ripple
        let rippleDotSize: CGFloat = 10
        let rippleInnerRingSize: CGFloat = 180
        let rippleOuterRingSize: CGFloat = 280
        let rippleDuration: Double = 0.5
        let resultDelay: Duration = .milliseconds(500)
    }
}
