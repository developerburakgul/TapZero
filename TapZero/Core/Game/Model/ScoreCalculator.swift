//
//  ScoreCalculator.swift
//  TapZero
//

import Foundation

enum ScoreCalculator {
    static let minTargetSeconds = 1
    static let maxTargetSeconds = 30
    static let maxScore = 1000

    /// Calculates score using the formula: round(1000 * max(0, 1 - delta/target)^2)
    /// - Parameters:
    ///   - targetSeconds: The target duration (1-30)
    ///   - tappedSeconds: The actual duration when user tapped
    /// - Returns: Score between 0 and 1000
    static func calculate(targetSeconds: Int, tappedSeconds: Double) -> Int {
        let delta = abs(tappedSeconds - Double(targetSeconds))
        let relativeError = delta / Double(targetSeconds)
        return Int(round(1000.0 * pow(max(0.0, 1.0 - relativeError), 2)))
    }
}
