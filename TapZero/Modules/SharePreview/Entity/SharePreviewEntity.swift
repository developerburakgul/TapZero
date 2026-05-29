//
//  SharePreviewEntity.swift
//  TapZero
//

import Foundation

struct SharePreviewEntity: Sendable {
    let score: Int
    let targetSeconds: Int
    let tappedSeconds: Double
    let delta: Double
    let performanceRating: PerformanceRating
}
