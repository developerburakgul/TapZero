//
//  FilterSortConfig.swift
//  TapZero
//

import Foundation

extension HistoryScreen.FilterSortEntity {
    struct Config: Equatable {
        let availableTargets: [Int]
        let gameCount: Int
    }
}
