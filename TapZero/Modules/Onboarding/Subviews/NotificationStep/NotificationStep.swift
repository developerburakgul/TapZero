//
//  NotificationStep.swift
//  TapZero
//

import SwiftUI

extension OnboardingScreen {
    struct NotificationStep: View, @MainActor Equatable {
        enum Action {
            case didTapEnable
            case didTapSkip
            case didTapContinue
        }

        @Binding var binding: NotificationStepEntity.Binding
        let config: NotificationStepEntity.Config
        let onAction: (Action) -> Void

        @State private var animateNotification: Bool = false
        @State private var loopActive: Bool = true

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                headerSection
                mockupSection
                Spacer()
                buttonSection
            }
            .padding(.horizontal, 24)
            .onAppear {
                loopActive = true
                animateNotification = false
            }
            .onDisappear { loopActive = false }
        }

        // MARK: - Header

        private var headerSection: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(config.title)
                    .font(TapZeroTypography.Display.large)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)

                Text(config.subtitle)
                    .font(TapZeroTypography.Body.medium)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
            }
            .padding(.top, 24)
        }

        // MARK: - Mockup

        private var mockupSection: some View {
            PhoneMockupView(width: 280) {
                MockAppGridView()
                notificationOverlay
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 16)
        }

        private var notificationOverlay: some View {
            NotificationBannerView(
                title: TextKey.Onboarding.notificationMockTitle,
                subtitle: TextKey.Onboarding.notificationMockSubtitle,
                icon: "bell.fill",
                iconColor: TapZeroDesign.Accent.primary
            )
            .padding(.horizontal, 12)
            .padding(.top, 40)
            .offset(y: animateNotification ? 0 : -200)
            .clipped()
            .task { await loopAnimation() }
        }

        // MARK: - Animation

        private func loopAnimation() async {
            try? await Task.sleep(for: .seconds(0.5))
            withAnimation(.spring(duration: 0.5, bounce: 0.3)) {
                animateNotification = true
            }

            try? await Task.sleep(for: .seconds(3.5))
            withAnimation(.easeIn(duration: 0.3)) {
                animateNotification = false
            }

            guard loopActive else { return }
            try? await Task.sleep(for: .seconds(1))
            await loopAnimation()
        }

        // MARK: - Buttons

        @ViewBuilder
        private var buttonSection: some View {
            if binding.permissionGranted {
                alreadyEnabledView
                continueButton
            } else {
                enableButton
                skipButton
            }
        }

        private var alreadyEnabledView: some View {
            VStack(spacing: 8) {
                Image(systemName: "bell.badge.checkmark.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(TapZeroDesign.System.systemGreen)

                Text(TextKey.Onboarding.notificationsEnabled)
                    .font(TapZeroTypography.Heading.h2)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
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
            .padding(.bottom, 16)
        }

        private var enableButton: some View {
            Button {
                onAction(.didTapEnable)
            } label: {
                Text(TextKey.Onboarding.enableNotifications)
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
                Text(TextKey.Onboarding.skipNotification)
                    .font(TapZeroTypography.Label.medium)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
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

// MARK: - Preview

private struct NotificationStepPreview: View {
    @State private var binding: OnboardingScreen.NotificationStepEntity.Binding

    init(permissionGranted: Bool = false) {
        _binding = State(initialValue: .init(permissionGranted: permissionGranted))
    }

    var body: some View {
        ZStack {
            TapZeroDesign.Background.primary.ignoresSafeArea()
            OnboardingScreen.NotificationStep(
                binding: $binding,
                config: .init(
                    title: TextKey.Onboarding.notificationTitle,
                    subtitle: TextKey.Onboarding.notificationSubtitle
                )
            ) { _ in }
        }
    }
}

#Preview("Not Determined") {
    NotificationStepPreview()
}

#Preview("Granted") {
    NotificationStepPreview(permissionGranted: true)
}
