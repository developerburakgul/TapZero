//
//  LeaderBoardRowConfig.swift
//  TapZero
//

import SwiftUI

extension LeaderBoardScreen.LeaderBoardRowEntity {
    struct Config: Equatable, Identifiable {
        let rank: Int
        let name: String
        let score: Int
        let avatarURL: String?
        let avatarColor: Color
        let isCurrentUser: Bool
        let isDense: Bool

        var id: String { "\(rank)-\(name)" }

        var initials: String {
            let parts = name.split(separator: " ")
            if parts.count >= 2 {
                return String(parts[0].prefix(1) + parts[1].prefix(1)).uppercased()
            }
            return String(name.prefix(2)).uppercased()
        }
    }
}
