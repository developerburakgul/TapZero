//
//  DeepLink.swift
//  TapZero
//

import Foundation

enum DeepLink: Equatable, Sendable {
    case tab(Tab)
}

// MARK: - Tab

extension DeepLink {
    enum Tab: String, CaseIterable, Sendable {
        case home
        case favorites
        case settings
    }
}
