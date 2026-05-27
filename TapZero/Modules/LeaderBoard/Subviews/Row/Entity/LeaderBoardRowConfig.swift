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
        let colorHex: String?
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

        var avatarColor: Color {
            guard let hex = colorHex else {
                let pastelColors = TapZeroPalette.Pastel.all
                let index = abs(name.hashValue) % pastelColors.count
                return Color(hex: pastelColors[index])
            }
            return Color(hex: hex)
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.rank == rhs.rank
                && lhs.name == rhs.name
                && lhs.score == rhs.score
                && lhs.avatarURL == rhs.avatarURL
                && lhs.isCurrentUser == rhs.isCurrentUser
                && lhs.isDense == rhs.isDense
        }
    }
}
