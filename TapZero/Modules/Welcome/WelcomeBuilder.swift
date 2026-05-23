//
//  WelcomeBuilder.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

@MainActor
enum WelcomeBuilder {
    static func build(
        router: Router,
        entity: WelcomeEntity = WelcomeEntity()
    ) -> some View {
        WelcomeScreen(
            viewModel: WelcomeViewModel(
                router: router,
                entity: entity
            )
        )
    }
}
