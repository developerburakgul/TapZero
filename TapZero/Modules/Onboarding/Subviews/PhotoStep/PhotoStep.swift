//
//  StepTwo.swift
//  TapZero
//

import SwiftUI

extension OnboardingScreen {
    struct PhotoStep: View, @MainActor Equatable {
        enum Action {
            case didTapContinue
            case didTapSkip
            case didTapCamera
            case didTapRemovePhoto
        }

        @Binding var binding: PhotoStepEntity.Binding
        let config: PhotoStepEntity.Config
        let onAction: (Action) -> Void

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text(config.title)
                    .font(TapZeroTypography.Display.large)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
                    .padding(.top, 24)

                Text(config.subtitle)
                    .font(TapZeroTypography.Body.medium)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
                    .padding(.top, 4)

                avatarView
                    .frame(maxWidth: .infinity)
                    .padding(.top, 48)

                Spacer()

                continueButton
                skipButton
            }
            .padding(.horizontal, 24)
        }

        private var avatarView: some View {
            avatarContent
                .overlay(alignment: .bottomTrailing) {
                    cameraButton
                }
                .overlay(alignment: .topLeading) {
                    if binding.selectedImage != nil {
                        removePhotoButton
                    }
                }
        }

        private var removePhotoButton: some View {
            Button {
                onAction(.didTapRemovePhoto)
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(TapZeroDesign.Background.primary)
                    .frame(width: 28, height: 28)
                    .background(TapZeroDesign.System.systemRed)
                    .clipShape(Circle())
            }
        }

        @ViewBuilder
        private var avatarContent: some View {
            if let image = binding.selectedImage {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 180, height: 180)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(TapZeroDesign.Background.secondary)
                    .overlay(
                        Circle()
                            .strokeBorder(
                                style: StrokeStyle(lineWidth: 1, dash: [6, 4])
                            )
                            .foregroundStyle(TapZeroDesign.Foreground.tertiary)
                    )
                    .overlay(
                        Text(binding.initial)
                            .font(.system(size: 64, weight: .medium))
                            .foregroundStyle(TapZeroDesign.Foreground.primary)
                    )
                    .frame(width: 180, height: 180)
            }
        }

        private var cameraButton: some View {
            Button {
                onAction(.didTapCamera)
            } label: {
                Image(systemName: "camera.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(TapZeroDesign.Background.primary)
                    .frame(width: 36, height: 36)
                    .background(TapZeroDesign.Foreground.primary)
                    .clipShape(Circle())
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
        }

        private var skipButton: some View {
            Button {
                onAction(.didTapSkip)
            } label: {
                Text(TextKey.Onboarding.skip)
                    .font(TapZeroTypography.Label.medium)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .padding(.bottom, 4)
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.binding == rhs.binding
            && lhs.config == rhs.config
        }
    }
}
