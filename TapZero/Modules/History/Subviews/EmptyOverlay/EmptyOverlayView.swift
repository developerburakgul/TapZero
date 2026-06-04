//
//  EmptyOverlayView.swift
//  TapZero
//

import SwiftUI

extension HistoryScreen {
    struct EmptyOverlayView: View, Equatable {
        enum Action {
            case didTapPlayGame
        }

        @Binding var binding: EmptyOverlayEntity.Binding
        let config: EmptyOverlayEntity.Config
        private let constants = Constants()
        let onAction: (Action) -> Void

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config
        }

        var body: some View {
            VStack(spacing: 0) {
                headerSection
                ctaButton
            }
            .padding(.horizontal, constants.cardPaddingH)
            .padding(.vertical, constants.cardPaddingV)
            .background(TapZeroDesign.Background.card)
            .clipShape(RoundedRectangle(cornerRadius: constants.cardRadius))
            .overlay(
                RoundedRectangle(cornerRadius: constants.cardRadius)
                    .stroke(TapZeroDesign.Hairline.default, lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.03), radius: 1, y: 1)
            .shadow(color: .black.opacity(0.08), radius: 20, y: 7)
            .padding(.horizontal, 16)
        }

        // MARK: - Header

        private var headerSection: some View {
            HStack(alignment: .top, spacing: 16) {
                progressRing

                VStack(alignment: .leading, spacing: 4) {
                    Text(TextKey.History.emptyOverlayTitle)
                        .font(.system(size: 16, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(TapZeroDesign.Foreground.primary)

                    Text(config.subtitle)
                        .font(.system(size: 13, weight: .medium))
                        .tracking(-0.1)
                        .lineSpacing(2)
                        .foregroundStyle(TapZeroDesign.Foreground.secondary)
                }

                Spacer()
            }
        }

        // MARK: - CTA Button

        private var ctaButton: some View {
            Button {
                onAction(.didTapPlayGame)
            } label: {
                Text(TextKey.History.emptyOverlayCta)
                    .font(TapZeroTypography.Label.button)
                    .tracking(-0.2)
                    .foregroundStyle(TapZeroDesign.Button.primaryForeground)
                    .frame(maxWidth: .infinity)
                    .frame(height: constants.ctaHeight)
                    .background(TapZeroDesign.Button.primaryBackground)
                    .clipShape(RoundedRectangle(cornerRadius: constants.ctaRadius))
            }
            .padding(.top, 18)
        }

        // MARK: - Progress Ring

        private var progressRing: some View {
            ZStack {
                Circle()
                    .stroke(TapZeroDesign.Hairline.default, lineWidth: constants.progressStrokeWidth)

                Circle()
                    .trim(from: 0, to: config.progress)
                    .stroke(
                        TapZeroDesign.Foreground.primary,
                        style: StrokeStyle(
                            lineWidth: constants.progressStrokeWidth,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))

                Text(TextKey.History.emptyOverlayProgress(
                    played: config.gamesPlayed,
                    required: config.gamesRequired
                ))
                    .font(.system(size: 16, weight: .bold))
                    .tracking(-0.4)
                    .monospacedDigit()
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
            }
            .frame(
                width: constants.progressSize,
                height: constants.progressSize
            )
        }
    }
}
