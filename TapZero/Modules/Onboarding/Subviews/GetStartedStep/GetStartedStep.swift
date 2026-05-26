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

        // MARK: - Animation States

        @State private var showCheck: Bool = false
        @State private var pulseHalo: Bool = false
        @State private var showTitle: Bool = false
        @State private var showCard: Bool = false
        @State private var showBenefit1: Bool = false
        @State private var showBenefit2: Bool = false
        @State private var showBenefit3: Bool = false
        @State private var showButton: Bool = false

        var body: some View {
            VStack(spacing: 0) {
                Spacer()

                checkmarkSection

                titleSection
                    .padding(.top, 22)
                    .opacity(showTitle ? 1 : 0)
                    .offset(y: showTitle ? 0 : 16)

                profileCard
                    .padding(.top, 26)
                    .opacity(showCard ? 1 : 0)
                    .offset(y: showCard ? 0 : 16)

                benefitsList
                    .padding(.top, 22)

                Spacer()

                continueButton
                    .opacity(showButton ? 1 : 0)
            }
            .padding(.horizontal, 28)
            .onAppear { runAnimations() }
        }

        // MARK: - Checkmark

        private var checkmarkSection: some View {
            ZStack {
                Circle()
                    .fill(TapZeroDesign.Status.good.opacity(0.10))
                    .frame(width: 104, height: 104)
                    .scaleEffect(pulseHalo ? 1.0 : 0.6)
                    .opacity(pulseHalo ? 1 : 0)

                Circle()
                    .fill(TapZeroDesign.Status.good)
                    .frame(width: 84, height: 84)
                    .shadow(color: TapZeroDesign.Status.good.opacity(0.3), radius: 10, y: 6)
                    .scaleEffect(showCheck ? 1.0 : 0.01)
                    .overlay {
                        Image(systemName: "checkmark")
                            .font(.system(size: 38, weight: .bold))
                            .foregroundStyle(.white)
                            .scaleEffect(showCheck ? 1.0 : 0.01)
                    }
            }
        }

        // MARK: - Title

        private var titleSection: some View {
            VStack(spacing: 10) {
                Text(TextKey.Onboarding.getStartedTitlePersonalized(config.name))
                    .font(TapZeroTypography.Heading.pageHeader)
                    .tracking(-0.9)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
                    .multilineTextAlignment(.center)

                Text(config.subtitle)
                    .font(TapZeroTypography.Body.medium)
                    .tracking(-0.1)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 18)
            }
        }

        // MARK: - Profile Card

        private var profileCard: some View {
            HStack(spacing: 14) {
                profileAvatar

                Text(config.name)
                    .font(TapZeroTypography.Heading.h2)
                    .tracking(-0.3)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)

                Spacer()
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(TapZeroDesign.Background.card)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(TapZeroDesign.Hairline.subtle, lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.03), radius: 1, y: 1)
        }

        private var profileAvatar: some View {
            Group {
                if let image = config.selectedImage {
                    image
                        .resizable()
                        .scaledToFill()
                } else {
                    Circle()
                        .fill(TapZeroDesign.Background.secondary)
                        .overlay(
                            Circle()
                                .stroke(TapZeroDesign.Hairline.default, lineWidth: 1)
                        )
                        .overlay(
                            Text(config.initial)
                                .font(.system(size: 24, weight: .medium))
                                .tracking(-1)
                                .foregroundStyle(TapZeroDesign.Foreground.primary)
                        )
                }
            }
            .frame(width: 48, height: 48)
            .clipShape(Circle())
        }

        // MARK: - Benefits

        private var benefitsList: some View {
            VStack(spacing: 10) {
                benefitRow(
                    icon: "chart.line.uptrend.xyaxis",
                    text: TextKey.Onboarding.getStartedBenefitStats,
                    iconColor: TapZeroDesign.Status.good,
                    bgColor: TapZeroDesign.Status.goodSoft,
                    visible: showBenefit1
                )
                benefitRow(
                    icon: "trophy.fill",
                    text: TextKey.Onboarding.getStartedBenefitLeaderboard,
                    iconColor: TapZeroDesign.Medal.gold,
                    bgColor: TapZeroDesign.Medal.gold.opacity(0.12),
                    visible: showBenefit2
                )
                benefitRow(
                    icon: "arrow.triangle.2.circlepath",
                    text: TextKey.Onboarding.getStartedBenefitSync,
                    iconColor: TapZeroDesign.Accent.primary,
                    bgColor: TapZeroDesign.Background.secondary,
                    visible: showBenefit3
                )
            }
        }

        private func benefitRow(
            icon: String,
            text: LocalizedStringKey,
            iconColor: Color,
            bgColor: Color,
            visible: Bool
        ) -> some View {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(iconColor)
                    .frame(width: 36, height: 36)
                    .background(bgColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                Text(text)
                    .font(TapZeroTypography.Body.listRow)
                    .tracking(-0.1)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(visible ? 1 : 0)
            .offset(y: visible ? 0 : 10)
        }

        // MARK: - Button

        private var continueButton: some View {
            Button {
                onAction(.didTapStart)
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

        // MARK: - Animation

        private func runAnimations() {
            showCheck = false
            pulseHalo = false
            showTitle = false
            showCard = false
            showBenefit1 = false
            showBenefit2 = false
            showBenefit3 = false
            showButton = false

            withAnimation(.spring(duration: 0.5, bounce: 0.4).delay(0.2)) {
                showCheck = true
            }

            withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                pulseHalo = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }

            withAnimation(.easeOut(duration: 0.4).delay(0.8)) {
                showTitle = true
            }

            withAnimation(.easeOut(duration: 0.4).delay(1.0)) {
                showCard = true
            }

            withAnimation(.easeOut(duration: 0.3).delay(1.2)) {
                showBenefit1 = true
            }

            withAnimation(.easeOut(duration: 0.3).delay(1.4)) {
                showBenefit2 = true
            }

            withAnimation(.easeOut(duration: 0.3).delay(1.6)) {
                showBenefit3 = true
            }

            withAnimation(.easeOut(duration: 0.3).delay(1.8)) {
                showButton = true
            }
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.binding == rhs.binding
            && lhs.config == rhs.config
        }
    }
}

// MARK: - Preview

private struct GetStartedStepPreview: View {
    let name: String
    let selectedImage: Image?
    @State private var binding = OnboardingScreen.GetStartedStepEntity.Binding()

    init(name: String = "Burak", selectedImage: Image? = nil) {
        self.name = name
        self.selectedImage = selectedImage
    }

    var body: some View {
        ZStack {
            TapZeroDesign.Background.primary.ignoresSafeArea()
            OnboardingScreen.GetStartedStep(
                binding: $binding,
                config: .init(
                    title: TextKey.Onboarding.getStartedTitle,
                    subtitle: TextKey.Onboarding.getStartedSubtitle,
                    name: name,
                    initial: String(name.prefix(1)).uppercased(),
                    selectedImage: selectedImage
                )
            ) { _ in }
        }
    }
}

#Preview("Without Photo") {
    GetStartedStepPreview()
}

#Preview("With Photo") {
    GetStartedStepPreview(selectedImage: Image(systemName: "person.crop.circle.fill"))
}
