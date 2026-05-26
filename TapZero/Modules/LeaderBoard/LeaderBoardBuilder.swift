//
//  LeaderBoardBuilder.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

@MainActor
enum LeaderBoardBuilder {
    static func build(
        router: Router,
        entity: LeaderBoardEntity = LeaderBoardEntity()
    ) -> some View {
        LeaderBoardScreen(
            viewModel: LeaderBoardViewModel(
                router: router,
                entity: entity
            )
        )
    }
}
