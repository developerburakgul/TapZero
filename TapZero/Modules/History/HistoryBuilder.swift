//
//  HistoryBuilder.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

@MainActor
enum HistoryBuilder {
    static func build(
        router: Router,
        entity: HistoryEntity = HistoryEntity()
    ) -> some View {
        HistoryScreen(
            viewModel: HistoryViewModel(
                router: router,
                entity: entity
            )
        )
    }
}
