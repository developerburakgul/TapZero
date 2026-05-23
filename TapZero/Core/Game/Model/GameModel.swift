//
//  GameModel.swift
//  TapZero
//

import Foundation

struct GameModel: Codable, Sendable, Identifiable {
    let gameId: String
    let targetSeconds: Int
    let tappedSeconds: Double
    let score: Int
    let playedAt: Date

    var id: String { gameId }

    var delta: Double {
        abs(tappedSeconds - Double(targetSeconds))
    }

    var performanceRating: PerformanceRating {
        PerformanceRating(delta: delta)
    }

    static var mock: Self {
        Self(
            gameId: "mock_game_1",
            targetSeconds: 15,
            tappedSeconds: 14.2,
            score: 871,
            playedAt: .now
        )
    }

    static var mocks: [Self] {
        [
            Self(
                gameId: "mock_game_1",
                targetSeconds: 30,
                tappedSeconds: 29.0,
                score: 935,
                playedAt: .now
            ),
            Self(
                gameId: "mock_game_2",
                targetSeconds: 15,
                tappedSeconds: 14.0,
                score: 871,
                playedAt: .now.addingTimeInterval(-3600)
            ),
            Self(
                gameId: "mock_game_3",
                targetSeconds: 5,
                tappedSeconds: 4.0,
                score: 640,
                playedAt: .now.addingTimeInterval(-7200)
            ),
            Self(
                gameId: "mock_game_4",
                targetSeconds: 20,
                tappedSeconds: 20.05,
                score: 995,
                playedAt: .now.addingTimeInterval(-10800)
            )
        ]
    }
}
