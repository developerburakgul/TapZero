//
//  GameResultBuilder.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

@MainActor
enum GameResultBuilder {
    static func build(
        router: Router,
        entity: GameResultEntity,
        onPlayAgain: @escaping () -> Void = {}
    ) -> some View {
        GameResultScreen(
            viewModel: GameResultViewModel(
                router: router,
                entity: entity,
                onPlayAgain: onPlayAgain
            )
        )
    }
}
