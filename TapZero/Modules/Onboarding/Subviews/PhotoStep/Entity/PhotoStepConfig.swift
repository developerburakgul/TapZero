//
//  StepTwoConfig.swift
//  TapZero
//

import SwiftUI

extension OnboardingScreen.PhotoStepEntity {
    struct Config: Equatable {
        let title: LocalizedStringKey
        let subtitle: LocalizedStringKey

        static func == (lhs: Self, rhs: Self) -> Bool {
            true
        }
    }
}
