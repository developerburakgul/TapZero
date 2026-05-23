//
//  HomeBuilder.swift
//  Created by __Username__ on __Date__
//

import SwiftUI
import SwiftfulRouting

@MainActor
enum HomeBuilder {

    static func build(
        router: Router,
        entity: HomeEntity = HomeEntity()
    ) -> some View {
        HomeScreen(
            viewModel: HomeViewModel(
                router: router,
                entity: entity
            )
        )
    }
}
