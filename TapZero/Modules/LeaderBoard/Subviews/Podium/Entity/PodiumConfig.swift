//
//  PodiumConfig.swift
//  TapZero
//

import SwiftUI

extension LeaderBoardScreen.PodiumEntity {
    struct Config: Equatable {
        let entries: [PodiumEntry]
    }

    struct PodiumEntry: Equatable, Identifiable {
        let rank: Int
        let name: String
        let score: Int
        let avatarURL: String?
        let avatarColor: Color
        let medalColor: Color
        let ribbonTextColor: Color

        var id: Int { rank }

        var initials: String {
            let parts = name.split(separator: " ")
            if parts.count >= 2 {
                return String(parts[0].prefix(1) + parts[1].prefix(1)).uppercased()
            }
            return String(name.prefix(2)).uppercased()
        }
    }
}
