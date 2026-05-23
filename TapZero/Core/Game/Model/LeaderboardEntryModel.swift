//
//  LeaderboardEntryModel.swift
//  TapZero
//

import Foundation

struct GlobalLeaderboardEntry: Codable, Sendable, Identifiable {
    let userId: String
    let name: String
    let avatar: String?
    let top10Average: Int
    let rank: Int
    let updatedAt: Date?

    var id: String { userId }

    static var mock: Self {
        Self(
            userId: "mock_user_123",
            name: "Burak",
            avatar: nil,
            top10Average: 887,
            rank: 1,
            updatedAt: .now
        )
    }

    static var mocks: [Self] {
        [
            Self(userId: "user_1", name: "Burak", avatar: nil, top10Average: 920, rank: 1, updatedAt: .now),
            Self(userId: "user_2", name: "Ali", avatar: nil, top10Average: 887, rank: 2, updatedAt: .now),
            Self(userId: "user_3", name: "Zeynep", avatar: nil, top10Average: 845, rank: 3, updatedAt: .now),
            Self(userId: "user_4", name: "Ayse", avatar: nil, top10Average: 790, rank: 4, updatedAt: .now),
            Self(userId: "user_5", name: "Mehmet", avatar: nil, top10Average: 735, rank: 5, updatedAt: .now)
        ]
    }
}

struct DailyLeaderboardEntry: Codable, Sendable, Identifiable {
    let userId: String
    let name: String
    let avatar: String?
    let bestScore: Int
    let rank: Int
    let updatedAt: Date?

    var id: String { userId }

    static var mock: Self {
        Self(
            userId: "mock_user_123",
            name: "Burak",
            avatar: nil,
            bestScore: 935,
            rank: 1,
            updatedAt: .now
        )
    }

    static var mocks: [Self] {
        [
            Self(userId: "user_1", name: "Burak", avatar: nil, bestScore: 995, rank: 1, updatedAt: .now),
            Self(userId: "user_2", name: "Ali", avatar: nil, bestScore: 935, rank: 2, updatedAt: .now),
            Self(userId: "user_3", name: "Zeynep", avatar: nil, bestScore: 871, rank: 3, updatedAt: .now),
            Self(userId: "user_4", name: "Ayse", avatar: nil, bestScore: 640, rank: 4, updatedAt: .now),
            Self(userId: "user_5", name: "Mehmet", avatar: nil, bestScore: 490, rank: 5, updatedAt: .now)
        ]
    }
}
