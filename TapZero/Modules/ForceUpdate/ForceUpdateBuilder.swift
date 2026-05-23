//
//  ForceUpdateBuilder.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

@MainActor
enum ForceUpdateBuilder {
    static func build(
        router: Router,
        entity: ForceUpdateEntity
    ) -> some View {
        ForceUpdateScreen(
            viewModel: ForceUpdateViewModel(
                router: router,
                entity: entity
            )
        )
    }
}
