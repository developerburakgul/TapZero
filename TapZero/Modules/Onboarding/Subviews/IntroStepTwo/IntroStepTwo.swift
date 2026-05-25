//
//  IntroStepTwo.swift
//  TapZero
//

import SwiftUI

extension OnboardingScreen {
    struct IntroStepTwo: View, @MainActor Equatable {
        @Binding var binding: IntroStepTwoEntity.Binding
        let config: IntroStepTwoEntity.Config

        @State private var headerOpacity: Double = 0
        @State private var cardStates: [Bool] = [false, false, false]

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                headerSection
                stepsSection
                Spacer()
            }
            .padding(.horizontal, 28)
            .padding(.top, 12)
            .onAppear { startAnimations() }
        }

        // MARK: - Header

        private var headerSection: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text(config.title)
                    .font(TapZeroTypography.Heading.pageHeader)
                    .tracking(-0.9)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)

                Text(config.subtitle)
                    .font(TapZeroTypography.Body.primary)
                    .tracking(-0.1)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
                    .lineSpacing(4)
            }
            .opacity(headerOpacity)
        }

        // MARK: - Steps

        private var stepsSection: some View {
            VStack(spacing: 10) {
                stepCard(
                    number: "1",
                    title: TextKey.Onboarding.howStep1Title,
                    body: TextKey.Onboarding.howStep1Body,
                    index: 0
                )
                stepCard(
                    number: "2",
                    title: TextKey.Onboarding.howStep2Title,
                    body: TextKey.Onboarding.howStep2Body,
                    index: 1
                )
                stepCard(
                    number: "3",
                    title: TextKey.Onboarding.howStep3Title,
                    body: TextKey.Onboarding.howStep3Body,
                    index: 2
                )
            }
            .padding(.top, 28)
        }

        private func stepCard(
            number: String,
            title: LocalizedStringKey,
            body: LocalizedStringKey,
            index: Int
        ) -> some View {
            HStack(alignment: .top, spacing: 16) {
                Text(number)
                    .font(.system(size: 14, weight: .bold))
                    .tracking(-0.2)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(TapZeroDesign.Background.primary)
                            .overlay(
                                Circle()
                                    .stroke(TapZeroDesign.Hairline.default, lineWidth: 1)
                            )
                    )

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(TapZeroDesign.Foreground.primary)

                    Text(body)
                        .font(TapZeroTypography.Body.hint)
                        .tracking(-0.1)
                        .foregroundStyle(TapZeroDesign.Foreground.secondary)
                        .lineSpacing(3)
                }
                .padding(.top, 3)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(TapZeroDesign.Background.card)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(TapZeroDesign.Hairline.default, lineWidth: 0.5)
            )
            .opacity(cardStates[index] ? 1 : 0)
            .offset(y: cardStates[index] ? 0 : 30)
        }

        // MARK: - Animation

        private func startAnimations() {
            withAnimation(.easeOut(duration: 0.4)) {
                headerOpacity = 1
            }
            for i in 0..<3 {
                withAnimation(.spring(duration: 0.5, bounce: 0.3).delay(0.2 + Double(i) * 0.12)) {
                    cardStates[i] = true
                }
            }
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.binding == rhs.binding && lhs.config == rhs.config
        }
    }
}
