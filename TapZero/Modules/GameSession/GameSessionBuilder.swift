//
//  GameSessionBuilder.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

@MainActor
enum GameSessionBuilder {
    static func build(
        router: Router,
        entity: GameSessionEntity
    ) -> some View {
        GameSessionScreen(
            viewModel: GameSessionViewModel(
                router: router,
                entity: entity
            )
        )
    }
}
