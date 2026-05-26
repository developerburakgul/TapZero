//
//  PlayBuilder.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

@MainActor
enum PlayBuilder {
    static func build(
        router: Router,
        entity: PlayEntity = PlayEntity()
    ) -> some View {
        PlayScreen(
            viewModel: PlayViewModel(
                router: router,
                entity: entity
            )
        )
    }
}
