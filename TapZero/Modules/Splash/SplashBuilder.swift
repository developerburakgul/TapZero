//
//  SplashBuilder.swift
//  Created by __Username__ on __Date__
//

import SwiftUI
import SwiftfulRouting

@MainActor
enum SplashBuilder {

    static func build(
        router: Router,
        entity: SplashEntity = SplashEntity()
    ) -> some View {
        SplashScreen(
            viewModel: SplashViewModel(
                router: router,
                entity: entity
            )
        )
    }
}
