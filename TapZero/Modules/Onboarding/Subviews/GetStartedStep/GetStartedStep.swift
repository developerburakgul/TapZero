//
//  GetStartedStep.swift
//  TapZero
//

import SwiftUI

extension OnboardingScreen {
    struct GetStartedStep: View, @MainActor Equatable {
        enum Action {
            case didTapStart
        }

        @Binding var binding: GetStartedStepEntity.Binding
        let config: GetStartedStepEntity.Config
        let onAction: (Action) -> Void

        @State private var showCheck: Bool = false
        @State private var pulseHalo: Bool = false
        @State private var showContent: Bool = false

        var body: some View {
            VStack(spacing: 0) {
                Spacer()
                checkmarkSection
                textSection
                Spacer()
                startButton
            }
            .padding(.horizontal, 24)
            .onAppear { runAnimations() }
        }

        // MARK: - Checkmark

        private var checkmarkSection: some View {
            ZStack {
                // Outer halo
                Circle()
                    .fill(TapZeroDesign.System.systemGreen.opacity(0.08))
                    .frame(width: 160, height: 160)
                    .scaleEffect(pulseHalo ? 1.0 : 0.6)
                    .opacity(pulseHalo ? 1 : 0)

                // Inner halo
                Circle()
                    .fill(TapZeroDesign.System.systemGreen.opacity(0.15))
                    .frame(width: 120, height: 120)
                    .scaleEffect(pulseHalo ? 1.0 : 0.7)
                    .opacity(pulseHalo ? 1 : 0)

                // Main circle
                Circle()
                    .fill(TapZeroDesign.System.systemGreen)
                    .frame(width: 80, height: 80)
                    .scaleEffect(showCheck ? 1.0 : 0.01)
                    .overlay {
                        Image(systemName: "checkmark")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(.white)
                            .scaleEffect(showCheck ? 1.0 : 0.01)
                    }
            }
        }

        // MARK: - Text

        private var textSection: some View {
            VStack(spacing: 4) {
                Text(config.title)
                    .font(TapZeroTypography.Display.large)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
                    .multilineTextAlignment(.center)

                Text(config.subtitle)
                    .font(TapZeroTypography.Body.medium)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 32)
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)
        }

        // MARK: - Button

        private var startButton: some View {
            Button {
                onAction(.didTapStart)
            } label: {
                Text(TextKey.Onboarding.getStartedButton)
                    .font(TapZeroTypography.Label.large)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(TapZeroDesign.Foreground.primary)
                    .foregroundStyle(TapZeroDesign.Background.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.bottom, 16)
            .opacity(showContent ? 1 : 0)
        }

        // MARK: - Animation

        private func runAnimations() {
            showCheck = false
            pulseHalo = false
            showContent = false

            withAnimation(.spring(duration: 0.5, bounce: 0.4).delay(0.2)) {
                showCheck = true
            }

            withAnimation(.easeOut(duration: 0.6).delay(0.5)) {
                pulseHalo = true
            }

            withAnimation(.easeOut(duration: 0.4).delay(0.8)) {
                showContent = true
            }
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.binding == rhs.binding
            && lhs.config == rhs.config
        }
    }
}
