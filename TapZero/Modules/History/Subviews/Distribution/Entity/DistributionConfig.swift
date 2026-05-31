//
//  DistributionConfig.swift
//  TapZero
//

import SwiftUI

extension HistoryScreen.DistributionEntity {
    struct Config: Equatable {
        let segments: [DistributionSegment]
    }

    struct DistributionSegment: Equatable, Identifiable {
        let id: String
        let rating: PerformanceRating
        let count: Int
        let percentage: Double
        let color: Color
    }
}
