//
//  StepOneBinding.swift
//  TapZero
//

import Foundation

extension OnboardingScreen.NameStepEntity {
    enum ValidationReason: Equatable {
        case tooShort
        case tooLong
    }

    enum ValidationState: Equatable {
        case idle
        case invalid(ValidationReason)
        case valid
    }

    struct Binding: Equatable {
        var inputText: String
        var validation: ValidationState = .idle
    }
}
