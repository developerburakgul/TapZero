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
                HStack(spacing: 8) {
                    TextField("", text: $binding.inputText, axis: .vertical)
                        .font(TapZeroTypography.Heading.h1)
                        .foregroundStyle(TapZeroDesign.Foreground.primary)

                    switch binding.validation {
                    case .idle:
                        EmptyView()
                    case .invalid:
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(TapZeroDesign.Status.bad)
                    case .valid:
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(TapZeroDesign.Status.good)
                    }
                }

                Rectangle()
                    .fill(TapZeroDesign.Foreground.tertiary)
                    .frame(height: 1)

                switch binding.validation {
                case .invalid(.tooShort):
                    Text(TextKey.Onboarding.nameMinLength)
                        .font(TapZeroTypography.Caption.subtitle)
                        .foregroundStyle(TapZeroDesign.Status.bad)
                case .invalid(.tooLong):
                    Text(TextKey.Onboarding.nameMaxLength)
                        .font(TapZeroTypography.Caption.subtitle)
                        .foregroundStyle(TapZeroDesign.Status.bad)
                default:
                    EmptyView()
                }
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
            .disabled(binding.validation != .valid)
            .opacity(binding.validation == .valid ? 1 : 0.4)
            .padding(.bottom, 16)
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.binding == rhs.binding
            && lhs.config == rhs.config
        }
    }
}

// MARK: - Preview

private struct NameStepPreview: View {
    let initialState: OnboardingScreen.NameStepEntity.ValidationState
    let inputText: String

    @State private var binding: OnboardingScreen.NameStepEntity.Binding

    init(
        inputText: String = "",
        state: OnboardingScreen.NameStepEntity.ValidationState = .idle
    ) {
        self.inputText = inputText
        self.initialState = state
        _binding = State(initialValue: .init(inputText: inputText, validation: state))
    }

    var body: some View {
        ZStack {
            TapZeroDesign.Background.primary.ignoresSafeArea()
            OnboardingScreen.NameStep(
                binding: $binding,
                config: .init(
                    title: TextKey.Onboarding.nameTitle,
                    subtitle: TextKey.Onboarding.nameSubtitle
                )
            ) { _ in }
        }
    }
}

#Preview("Idle") {
    NameStepPreview()
}

#Preview("Too Short") {
    NameStepPreview(inputText: "A", state: .invalid(.tooShort))
}

#Preview("Too Long") {
    NameStepPreview(
        inputText: String(repeating: "A", count: 80),
        state: .invalid(.tooLong)
    )
}

#Preview("Valid") {
    NameStepPreview(inputText: "Burak", state: .valid)
}
