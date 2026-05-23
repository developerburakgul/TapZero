//
//  EmailAuthBuilder.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

@MainActor
enum EmailAuthBuilder {
    static func build(
        router: Router,
        entity: EmailAuthEntity = EmailAuthEntity()
    ) -> some View {
        EmailAuthScreen(
            viewModel: EmailAuthViewModel(
                router: router,
                entity: entity
            )
        )
    }
}
