//
//  StepOne.swift
//  TapZero
//

import SwiftUI

extension OnboardingScreen {
    struct NameStep: View, @MainActor Equatable {
        enum Action {
            case didTapContinue
        }

        @Binding var binding: NameStepEntity.Binding
        let config: NameStepEntity.Config
        let onAction: (Action) -> Void

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text(config.title)
                    .font(TapZeroTypography.Display.large)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
                    .padding(.top, 24)

                nameField
                    .padding(.top, 32)

                Text(config.subtitle)
                    .font(TapZeroTypography.Body.medium)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
                    .padding(.top, 8)

                Spacer()

                continueButton
            }
            .padding(.horizontal, 24)
        }

        private var nameField: some View {
            VStack(alignment: .leading, spacing: 6) {
                TextField("", text: $binding.inputText)
                    .font(TapZeroTypography.Heading.h1)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)

                Rectangle()
                    .fill(TapZeroDesign.Foreground.tertiary)
                    .frame(height: 1)
            }
        }

        private var continueButton: some View {
            Button {
                onAction(.didTapContinue)
            } label: {
                Text(TextKey.Onboarding.continueButton)
                    .font(TapZeroTypography.Label.large)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(TapZeroDesign.Foreground.primary)
                    .foregroundStyle(TapZeroDesign.Background.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(binding.inputText.trimmingCharacters(in: .whitespaces).isEmpty)
            .opacity(binding.inputText.trimmingCharacters(in: .whitespaces).isEmpty ? 0.4 : 1)
            .padding(.bottom, 16)
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.binding == rhs.binding
            && lhs.config == rhs.config
        }
    }
}
