//
//  IntroStepTwo.swift
//  TapZero
//

import SwiftUI

extension OnboardingScreen {
    private struct FeatureCardItem {
        let symbol: String
        let titleKey: String
        let color: Color
    }

    struct IntroStepTwo: View, @MainActor Equatable {
        enum Action {
            case didTapContinue
        }

        @Binding var binding: IntroStepTwoEntity.Binding
        let config: IntroStepTwoEntity.Config
        let onAction: (Action) -> Void

        @State private var cardStates: [Bool] = [false, false, false]
        @State private var showContent: Bool = false

        private let cards: [FeatureCardItem] = [
            .init(
                symbol: "lock.shield.fill",
                titleKey: "onboarding.intro2.card1",
                color: TapZeroDesign.System.systemGreen
            ),
            .init(
                symbol: "wand.and.stars",
                titleKey: "onboarding.intro2.card2",
                color: TapZeroDesign.Accent.primary
            ),
            .init(
                symbol: "chart.bar.fill",
                titleKey: "onboarding.intro2.card3",
                color: TapZeroDesign.System.systemOrange
            )
        ]

        var body: some View {
            VStack(spacing: 0) {
                Spacer()
                cardStack
                textSection
                Spacer()
                continueButton
            }
            .padding(.horizontal, 24)
            .onAppear { runAnimations() }
        }

        // MARK: - Card Stack

        private var cardStack: some View {
            ZStack {
                ForEach(
                    Array(cards.enumerated()),
                    id: \.offset
                ) { index, card in
                    featureCard(card: card, index: index)
                }
            }
            .frame(height: 280)
        }

        private func featureCard(
            card: FeatureCardItem,
            index: Int
        ) -> some View {
            let isVisible = cardStates[index]
            let yOffset = CGFloat(index) * 28
            let scale = 1.0 - CGFloat(index) * 0.06

            return HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(card.color.opacity(0.12))
                        .frame(width: 52, height: 52)

                    Image(systemName: card.symbol)
                        .font(.system(size: 22))
                        .foregroundStyle(card.color)
                }

                Text(LocalizedStringKey(card.titleKey))
                    .font(TapZeroTypography.Label.medium)
                    .foregroundStyle(
                        TapZeroDesign.Foreground.primary
                    )

                Spacer()
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(TapZeroDesign.Background.secondary)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(
                color: .black.opacity(0.08),
                radius: 16,
                x: 0,
                y: 8
            )
            .scaleEffect(isVisible ? scale : 0.7)
            .offset(y: isVisible ? yOffset : 80)
            .opacity(isVisible ? 1 : 0)
            .zIndex(Double(cards.count - index))
        }

        // MARK: - Text

        private var textSection: some View {
            VStack(spacing: 8) {
                Text(config.title)
                    .font(TapZeroTypography.Display.medium)
                    .foregroundStyle(
                        TapZeroDesign.Foreground.primary
                    )
                    .multilineTextAlignment(.center)

                Text(config.subtitle)
                    .font(TapZeroTypography.Body.medium)
                    .foregroundStyle(
                        TapZeroDesign.Foreground.secondary
                    )
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)
        }

        // MARK: - Button

        private var continueButton: some View {
            Button {
                onAction(.didTapContinue)
            } label: {
                Text(TextKey.Onboarding.continueButton)
                    .font(TapZeroTypography.Label.large)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        TapZeroDesign.Foreground.primary
                    )
                    .foregroundStyle(
                        TapZeroDesign.Background.primary
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.bottom, 16)
            .opacity(showContent ? 1 : 0)
        }

        // MARK: - Animation

        private func runAnimations() {
            cardStates = [false, false, false]
            showContent = false

            for index in cards.indices {
                let delay = 0.15 + Double(index) * 0.15
                withAnimation(
                    .spring(duration: 0.6, bounce: 0.35)
                    .delay(delay)
                ) {
                    cardStates[index] = true
                }
            }

            let contentDelay = 0.15 + Double(cards.count) * 0.15 + 0.2
            withAnimation(
                .easeOut(duration: 0.4).delay(contentDelay)
            ) {
                showContent = true
            }
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.binding == rhs.binding
            && lhs.config == rhs.config
        }
    }
}
