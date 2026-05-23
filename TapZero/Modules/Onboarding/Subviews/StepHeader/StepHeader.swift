//
//  StepHeader.swift
//  TapZero
//

import SwiftUI

extension OnboardingScreen {
    struct StepHeader: View {
        let currentStep: Int
        let totalSteps: Int
        let showBack: Bool
        let onBack: () -> Void

        var body: some View {
            ZStack {
                Text(TextKey.Onboarding.stepIndicator(current: currentStep, total: totalSteps))
                    .font(TapZeroTypography.Caption.medium)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
                    .frame(maxWidth: .infinity)

                if showBack {
                    HStack {
                        Button(action: onBack) {
                            Image(systemName: "chevron.left")
                                .font(.body.weight(.medium))
                                .foregroundStyle(TapZeroDesign.Foreground.primary)
                        }
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
        }
    }
}
