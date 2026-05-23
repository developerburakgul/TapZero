//
//  FavoritesBuilder.swift
//  Created by __Username__ on __Date__
//

import SwiftUI
import SwiftfulRouting

@MainActor
enum FavoritesBuilder {

    static func build(
        router: Router,
        entity: FavoritesEntity = FavoritesEntity()
    ) -> some View {
        FavoritesScreen(
            viewModel: FavoritesViewModel(
                router: router,
                entity: entity
            )
        )
    }
}
