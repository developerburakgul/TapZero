//
//  TabbarBuilder.swift
//  Created by __Username__ on __Date__
//

import SwiftUI
import SwiftfulRouting

@MainActor
enum TabbarBuilder {

    static func build(
        router: Router,
        entity: TabbarEntity = TabbarEntity()
    ) -> some View {
        TabbarScreen(
            viewModel: TabbarViewModel(
                router: router,
                entity: entity
            )
        )
    }
}
