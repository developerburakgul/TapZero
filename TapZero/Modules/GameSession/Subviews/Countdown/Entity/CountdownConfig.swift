//
//  CountdownConfig.swift
//  TapZero
//

import Foundation

extension GameSessionScreen.CountdownEntity {
    struct Config: Equatable {
        let countdownValue: Int
        let showGo: Bool
    }
}
