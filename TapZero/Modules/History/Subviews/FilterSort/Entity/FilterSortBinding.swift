//
//  FilterSortBinding.swift
//  TapZero
//

import Foundation

extension HistoryScreen.FilterSortEntity {
    struct Binding: Equatable {
        var selectedTarget: Int?
        var sortOrder: SortOrder = .newest
    }

    enum SortOrder: String, Equatable, CaseIterable {
        case newest
        case oldest
        case best
        case worst
    }
}
