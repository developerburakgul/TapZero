//
//  NetworkStatusBuilder.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

@MainActor
enum NetworkStatusBuilder {
    static func build(
        router: Router,
        entity: NetworkStatusEntity = NetworkStatusEntity()
    ) -> some View {
        NetworkStatusScreen(
            viewModel: NetworkStatusViewModel(
                router: router,
                entity: entity
            )
        )
    }
}
