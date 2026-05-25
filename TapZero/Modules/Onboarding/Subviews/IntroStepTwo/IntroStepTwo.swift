//
//  IntroStepTwo.swift
//  TapZero
//

import SwiftUI

extension OnboardingScreen {
    struct IntroStepTwo: View, @MainActor Equatable {
        @Binding var binding: IntroStepTwoEntity.Binding
        let config: IntroStepTwoEntity.Config

        static let cardCount = FeatureCard.allCases.count

        var body: some View {
            VStack(spacing: 0) {
                headerSection
                cardView
                    .frame(maxHeight: .infinity)
            }
        }

        // MARK: - Header

        private var headerSection: some View {
            Text(config.title)
                .font(TapZeroTypography.Heading.pageHeader)
                .tracking(-0.9)
                .foregroundStyle(TapZeroDesign.Foreground.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 28)
                .padding(.top, 12)
        }

        // MARK: - Card

        private var cardView: some View {
            let card = FeatureCard.allCases[binding.currentCard]

            return VStack(spacing: 0) {
                Text(card.captionKey)
                    .font(TapZeroTypography.Body.primary)
                    .tracking(-0.1)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
                    .padding(.top, 12)
                    .animation(.easeInOut(duration: 0.3), value: binding.currentCard)

                Spacer()

                PhoneMockupView(width: 240) {
                    // TODO: Her kart için gerçek app ekranı eklenecek
                    card.placeholder
                }
                .animation(.easeInOut(duration: 0.3), value: binding.currentCard)
            }
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.binding == rhs.binding && lhs.config == rhs.config
        }
    }
}

// MARK: - Feature Card Data

@MainActor
enum FeatureCard: String, CaseIterable, Identifiable {
    case pickTarget
    case gameplay
    case score

    var id: String { rawValue }

    var captionKey: LocalizedStringKey {
        switch self {
        case .pickTarget: TextKey.Onboarding.howStep1Body
        case .gameplay: TextKey.Onboarding.howStep2Body
        case .score: TextKey.Onboarding.howStep3Body
        }
    }

    // Placeholder — app ekranları hazır olunca gerçek content ile değiştirilecek
    @ViewBuilder
    var placeholder: some View {
        switch self {
        case .pickTarget:
            placeholderPickTarget
        case .gameplay:
            placeholderGameplay
        case .score:
            placeholderScore
        }
    }

    private var placeholderPickTarget: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 40)
            Text("5")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundStyle(TapZeroDesign.Foreground.primary.opacity(0.12))
            Text("seconds")
                .font(TapZeroTypography.Caption.subtitle)
                .foregroundStyle(TapZeroDesign.Foreground.tertiary)
            Spacer()
        }
    }

    private var placeholderGameplay: some View {
        VStack(spacing: 16) {
            Spacer()
            Circle()
                .stroke(TapZeroDesign.Foreground.primary.opacity(0.06), lineWidth: 2)
                .frame(width: 100, height: 100)
                .overlay(
                    Circle()
                        .fill(TapZeroDesign.Foreground.primary.opacity(0.04))
                        .frame(width: 40, height: 40)
                )
            Text("tap")
                .font(TapZeroTypography.Caption.subtitle)
                .foregroundStyle(TapZeroDesign.Foreground.tertiary)
            Spacer()
        }
    }

    private var placeholderScore: some View {
        VStack(spacing: 12) {
            Spacer().frame(height: 40)
            Text("0.03")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(TapZeroDesign.Status.good.opacity(0.2))
            Text("seconds off")
                .font(TapZeroTypography.Caption.subtitle)
                .foregroundStyle(TapZeroDesign.Foreground.tertiary)
            RoundedRectangle(cornerRadius: 8)
                .fill(TapZeroDesign.Status.good.opacity(0.06))
                .frame(width: 120, height: 32)
                .overlay(
                    Text("Perfect!")
                        .font(TapZeroTypography.Caption.small)
                        .foregroundStyle(TapZeroDesign.Status.good.opacity(0.3))
                )
            Spacer()
        }
    }
}
