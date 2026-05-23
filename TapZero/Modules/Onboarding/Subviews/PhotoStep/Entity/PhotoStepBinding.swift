//
//  StepTwoBinding.swift
//  TapZero
//

import SwiftUI

extension OnboardingScreen.PhotoStepEntity {
    struct Binding: Equatable {
        var initial: String
        var selectedImage: Image?
        var imageVersion: Int = 0

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.initial == rhs.initial
            && lhs.imageVersion == rhs.imageVersion
        }
    }
}
