//
//  SettingsBuilder.swift
//  Created by __Username__ on __Date__
//

import SwiftfulRouting
import SwiftUI

@MainActor
enum SettingsBuilder {
    static func build(
        router: Router,
        appRouter: Router? = nil,
        entity: SettingsEntity = SettingsEntity()
    ) -> some View {
        SettingsScreen(
            viewModel: SettingsViewModel(
                router: router,
                appRouter: appRouter,
                entity: entity
            )
        )
    }
}
