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
                    card.preview
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

    @ViewBuilder
    var preview: some View {
        switch self {
        case .pickTarget:
            previewPickTarget
        case .gameplay:
            previewGameplay
        case .score:
            previewScore
        }
    }

    // MARK: - Pick Target Preview

    private var previewPickTarget: some View {
        VStack(spacing: 0) {
            pickTargetUserStrip
            Spacer()
            pickTargetCenter
            Spacer()
            pickTargetButton
        }
    }

    private var previewName: String {
        TextKey.localized("onboarding.preview.userName")
    }

    private var pickTargetUserStrip: some View {
        HStack {
            InitialAvatarView(initial: String(previewName.prefix(1)), size: 26)

            VStack(alignment: .leading, spacing: 0) {
                Text(TextKey.Play.greeting)
                    .font(.system(size: 8, weight: .medium))
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
                Text(previewName)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 0) {
                Text(TextKey.Play.bestLabel)
                    .font(.system(size: 8, weight: .medium))
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
                Text(TextKey.number(847))
                    .font(.system(size: 11, weight: .semibold).monospacedDigit())
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
            }
        }
        .padding(.horizontal, 18)
        .padding(.top, 36)
    }

    private var pickTargetCenter: some View {
        VStack(spacing: 0) {
            Text(TextKey.Play.target)
                .font(.system(size: 8, weight: .bold))
                .tracking(1.2)
                .textCase(.uppercase)
                .foregroundStyle(TapZeroDesign.Foreground.secondary)

            HStack(alignment: .center, spacing: 2) {
                Text(TextKey.number(8))
                    .font(.system(size: 18, weight: .regular).monospacedDigit())
                    .foregroundStyle(TapZeroDesign.Foreground.primary.opacity(0.08))
                Text(TextKey.number(9))
                    .font(.system(size: 26, weight: .medium).monospacedDigit())
                    .foregroundStyle(TapZeroDesign.Foreground.primary.opacity(0.20))
                Text(TextKey.number(10))
                    .font(.system(size: 52, weight: .bold).monospacedDigit())
                    .tracking(-3)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
                    .lineLimit(1)
                    .fixedSize()
                Text(TextKey.number(11))
                    .font(.system(size: 26, weight: .medium).monospacedDigit())
                    .foregroundStyle(TapZeroDesign.Foreground.primary.opacity(0.20))
                Text(TextKey.number(12))
                    .font(.system(size: 18, weight: .regular).monospacedDigit())
                    .foregroundStyle(TapZeroDesign.Foreground.primary.opacity(0.08))
            }
            .padding(.vertical, 8)

            Text(TextKey.Play.secondsLabel(count: 10))
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(TapZeroDesign.Foreground.secondary)
        }
    }

    private var pickTargetButton: some View {
        Text(TextKey.Play.playButton)
            .font(.system(size: 12, weight: .semibold))
            .tracking(-0.2)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(TapZeroDesign.Button.primaryBackground)
            .foregroundStyle(TapZeroDesign.Button.primaryForeground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 18)
            .padding(.bottom, 14)
    }

    // MARK: - Gameplay Preview

    private var previewGameplay: some View {
        ZStack {
            VStack(spacing: 4) {
                Text(TextKey.GameSession.targetLabel)
                    .font(.system(size: 9, weight: .semibold))
                    .tracking(1.4)
                    .textCase(.uppercase)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)

                HStack(alignment: .firstTextBaseline, spacing: 1) {
                    Text(String(format: "%.2f", 5.0))
                        .font(.system(size: 26, weight: .bold))
                        .tracking(-0.8)
                        .monospacedDigit()
                        .foregroundStyle(TapZeroDesign.Foreground.primary)

                    Text(TextKey.Common.secondsAbbr)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(TapZeroDesign.Foreground.secondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 44)

            Text(TextKey.GameSession.tapHint)
                .font(.system(size: 9, weight: .regular))
                .tracking(0.4)
                .foregroundStyle(TapZeroDesign.Foreground.tertiary)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 36)
        }
    }

    // MARK: - Score Preview

    private var previewScore: some View {
        let offText = String(format: "%.2fs ", 0.08) + TextKey.localized("gameResult.offSuffix")

        return ScoreCardView(
            config: .init(
                score: 847,
                scoreColor: TapZeroDesign.Status.good,
                offLabelText: offText,
                offPillBackground: TapZeroDesign.Score.goodBackground,
                isPerfect: false,
                targetTimeFormatted: String(format: "%.2f", 5.0),
                tappedTimeFormatted: String(format: "%.2f", 5.08),
                timelineUserOffset: 0.08 * 0.4,
                targetSeconds: 5,
                userName: previewName
            ),
            constants: ScoreCardView.Constants()
        )
        .scaleEffect(0.6, anchor: .top)
        .padding(.top, 34)
    }
}
