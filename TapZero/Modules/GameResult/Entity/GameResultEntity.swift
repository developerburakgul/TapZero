//
//  GameResultEntity.swift
//  TapZero
//

import Foundation

struct GameResultEntity: Sendable {
    let score: Int
    let targetSeconds: Int
    let tappedSeconds: Double
    let delta: Double
    let performanceRating: PerformanceRating
}
