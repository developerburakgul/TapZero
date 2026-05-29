//
//  SharePreviewBuilder.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

@MainActor
enum SharePreviewBuilder {
    static func build(
        router: Router,
        entity: SharePreviewEntity
    ) -> some View {
        SharePreviewScreen(
            viewModel: SharePreviewViewModel(
                router: router,
                entity: entity
            )
        )
    }
}
