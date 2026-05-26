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

        private var hasPhoto: Bool {
            binding.selectedImage != nil
        }

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

                avatarSection
                    .frame(maxWidth: .infinity)
                    .padding(.top, 48)

                Spacer()

                if hasPhoto {
                    continueButton
                } else {
                    skipButton
                }
            }
            .padding(.horizontal, 24)
        }

        // MARK: - Avatar

        private var avatarSection: some View {
            VStack(spacing: 16) {
                avatarContent
                    .overlay(alignment: .bottomTrailing) {
                        cameraButton
                    }

                if hasPhoto {
                    removeButton
                }
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

        private var removeButton: some View {
            Button {
                onAction(.didTapRemovePhoto)
            } label: {
                Text(TextKey.Onboarding.photoRemove)
                    .font(TapZeroTypography.Caption.subtitle)
                    .foregroundStyle(TapZeroDesign.Status.bad)
            }
        }

        // MARK: - Actions

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
            .padding(.bottom, 16)
        }

        private var skipButton: some View {
            Button {
                onAction(.didTapSkip)
            } label: {
                Text(TextKey.Onboarding.skip)
                    .font(TapZeroTypography.Label.medium)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .padding(.bottom, 4)
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.binding == rhs.binding
            && lhs.config == rhs.config
        }
    }
}

// MARK: - Preview

private struct PhotoStepPreview: View {
    @State private var binding: OnboardingScreen.PhotoStepEntity.Binding

    init(initial: String = "B", selectedImage: Image? = nil) {
        _binding = State(initialValue: .init(
            initial: initial,
            selectedImage: selectedImage
        ))
    }

    var body: some View {
        ZStack {
            TapZeroDesign.Background.primary.ignoresSafeArea()
            OnboardingScreen.PhotoStep(
                binding: $binding,
                config: .init(
                    title: TextKey.Onboarding.photoTitle,
                    subtitle: TextKey.Onboarding.photoSubtitle
                )
            ) { _ in }
        }
    }
}

#Preview("Empty") {
    PhotoStepPreview()
}

#Preview("With Photo") {
    PhotoStepPreview(selectedImage: Image(systemName: "person.crop.circle.fill"))
}
