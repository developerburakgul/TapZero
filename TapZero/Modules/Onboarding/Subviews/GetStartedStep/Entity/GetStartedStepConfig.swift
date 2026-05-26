//
//  StepFourConfig.swift
//  TapZero
//

import SwiftUI

extension OnboardingScreen.GetStartedStepEntity {
    struct Config: Equatable {
        let title: LocalizedStringKey
        let subtitle: LocalizedStringKey
        var name: String = ""
        var initial: String = ""
        var selectedImage: Image?

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.name == rhs.name
            && lhs.initial == rhs.initial
        }
    }
}
