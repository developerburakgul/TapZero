//
//  OnboardingBuilder.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

@MainActor
enum OnboardingBuilder {
    static func build(
        router: Router,
        entity: OnboardingEntity = OnboardingEntity()
    ) -> some View {
        OnboardingScreen(
            viewModel: OnboardingViewModel(
                router: router,
                entity: entity
            )
        )
    }
}
