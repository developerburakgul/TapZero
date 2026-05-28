//
//  LockedOverlayView.swift
//  TapZero
//

import SwiftUI

extension LeaderBoardScreen {
    struct LockedOverlayView: View, Equatable {
        enum Action {
            case didTapPlayGame
        }

        @Binding var binding: LockedOverlayEntity.Binding
        let config: LockedOverlayEntity.Config
        let constants: Constants
        let onAction: (Action) -> Void

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config
        }

        var body: some View {
            VStack(spacing: 0) {
                headerSection
                divider
                whySection
                ctaButton
            }
            .padding(.horizontal, constants.lockedCardPaddingH)
            .padding(.vertical, constants.lockedCardPaddingV)
            .background(TapZeroDesign.Background.card)
            .clipShape(RoundedRectangle(cornerRadius: constants.lockedCardRadius))
            .overlay(
                RoundedRectangle(cornerRadius: constants.lockedCardRadius)
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
                    Text(TextKey.LeaderBoard.lockedTitle)
                        .font(.system(size: 16, weight: .bold))
                        .tracking(-0.3)
                        .foregroundStyle(TapZeroDesign.Foreground.primary)

                    Text(TextKey.LeaderBoard.lockedSubtitle(count: config.gamesRemaining))
                    .font(.system(size: 13, weight: .medium))
                    .tracking(-0.1)
                    .lineSpacing(2)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
                }

                Spacer()
            }
        }

        // MARK: - Divider

        private var divider: some View {
            Rectangle()
                .fill(TapZeroDesign.Hairline.default)
                .frame(height: 0.5)
                .padding(.horizontal, constants.lockedDividerMarginH)
                .padding(.top, 18)
                .padding(.bottom, 14)
        }

        // MARK: - Why Section

        private var whySection: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(TextKey.LeaderBoard.lockedWhyTitle)
                    .font(TapZeroTypography.Caption.sectionHeader)
                    .tracking(1.2)
                    .textCase(.uppercase)
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)

                Text(TextKey.LeaderBoard.lockedWhyBody)
                    .font(.system(size: 13, weight: .regular))
                    .tracking(-0.1)
                    .lineSpacing(3)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }

        // MARK: - CTA Button

        private var ctaButton: some View {
            Button {
                onAction(.didTapPlayGame)
            } label: {
                Text(TextKey.LeaderBoard.lockedCta)
                    .font(TapZeroTypography.Label.button)
                    .tracking(-0.2)
                    .foregroundStyle(TapZeroDesign.Button.primaryForeground)
                    .frame(maxWidth: .infinity)
                    .frame(height: constants.lockedCtaHeight)
                    .background(TapZeroDesign.Button.primaryBackground)
                    .clipShape(RoundedRectangle(cornerRadius: constants.lockedCtaRadius))
            }
            .padding(.top, 18)
        }

        // MARK: - Progress Ring

        private var progressRing: some View {
            ZStack {
                Circle()
                    .stroke(TapZeroDesign.Hairline.default, lineWidth: constants.lockedProgressStrokeWidth)

                Circle()
                    .trim(from: 0, to: config.progress)
                    .stroke(
                        TapZeroDesign.Foreground.primary,
                        style: StrokeStyle(
                            lineWidth: constants.lockedProgressStrokeWidth,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))

                Text(TextKey.LeaderBoard.lockedProgress(
                    played: config.gamesPlayed,
                    required: config.gamesRequired
                ))
                    .font(.system(size: 16, weight: .bold))
                    .tracking(-0.4)
                    .monospacedDigit()
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
            }
            .frame(
                width: constants.lockedProgressSize,
                height: constants.lockedProgressSize
            )
        }
    }
}

// MARK: - Previews

private struct LockedPreview: View {
    @State private var entity: LeaderBoardScreen.LockedOverlayEntity

    init(played: Int) {
        let remaining = max(0, 10 - played)
        let progress = CGFloat(played) / 10.0
        _entity = State(initialValue: .init(
            binding: .init(),
            config: .init(
                gamesPlayed: played, gamesRequired: 10,
                gamesRemaining: remaining, progress: progress
            )
        ))
    }

    var body: some View {
        ZStack {
            TapZeroDesign.Background.primary.ignoresSafeArea()
            LeaderBoardScreen.LockedOverlayView(
                binding: $entity.binding,
                config: entity.config,
                constants: .init()
            ) { _ in }
        }
    }
}

#Preview("New User — 0/10") {
    LockedPreview(played: 0)
}

#Preview("Getting Started — 3/10") {
    LockedPreview(played: 3)
}

#Preview("Almost There — 9/10") {
    LockedPreview(played: 9)
}

#Preview("Just One More — 1 game left") {
    LockedPreview(played: 9)
}
