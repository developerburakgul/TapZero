//
//  OnboardingViewModel+Validator.swift
//  TapZero
//

import Foundation

// MARK: - Validator
extension OnboardingViewModel {
    private static let nameMinLength = 2
    private static let nameMaxLength = 75

    func validateName() {
        let trimmed = nameStep.binding.inputText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        if trimmed.count < Self.nameMinLength {
            nameStep.binding.validation = .invalid(.tooShort)
        } else if trimmed.count > Self.nameMaxLength {
            nameStep.binding.validation = .invalid(.tooLong)
        } else {
            nameStep.binding.validation = .valid
        }
    }
}
