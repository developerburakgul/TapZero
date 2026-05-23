//
//  CreateAccountBuilder.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

@MainActor
enum CreateAccountBuilder {
    static func build(
        router: Router,
        entity: CreateAccountEntity = CreateAccountEntity(),
        onComplete: (@MainActor () -> Void)? = nil
    ) -> some View {
        CreateAccountScreen(
            viewModel: CreateAccountViewModel(
                router: router,
                entity: entity,
                onComplete: onComplete
            )
        )
    }
}
