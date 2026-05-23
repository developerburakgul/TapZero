//
//  PerformanceRating.swift
//  TapZero
//

import Foundation

enum PerformanceRating: String, Sendable, CaseIterable {
    case perfect
    case good
    case mid
    case bad

    init(delta: Double) {
        if delta <= 0.02 {
            self = .perfect
        } else if delta < 0.25 {
            self = .good
        } else if delta < 0.75 {
            self = .mid
        } else {
            self = .bad
        }
    }
}
