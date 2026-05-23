//
//  StepOneConfig.swift
//  TapZero
//

import SwiftUI

extension OnboardingScreen.NameStepEntity {
    struct Config: Equatable {
        let title: LocalizedStringKey
        let subtitle: LocalizedStringKey

        static func == (lhs: Self, rhs: Self) -> Bool {
            true
        }
    }
}
