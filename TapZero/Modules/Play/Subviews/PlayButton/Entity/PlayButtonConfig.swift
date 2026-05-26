//
//  PlayButtonConfig.swift
//  TapZero
//

import SwiftUI

extension PlayScreen.PlayButtonEntity {
    struct Config: Equatable {
        let buttonLabel: LocalizedStringKey

        static func == (lhs: Self, rhs: Self) -> Bool {
            true
        }
    }
}
