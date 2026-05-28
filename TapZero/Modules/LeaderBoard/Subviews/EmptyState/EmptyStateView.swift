//
//  EmptyStateView.swift
//  TapZero
//

import SwiftUI

extension LeaderBoardScreen {
    struct EmptyStateView: View, Equatable {
        enum Action {
            case didTapPlayGame
        }

        @Binding var binding: EmptyStateEntity.Binding
        let config: EmptyStateEntity.Config
        let constants: Constants
        let onAction: (Action) -> Void

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config
        }

        var body: some View {
            VStack(spacing: 0) {
                ghostPodium
                YourSpotRowView(
                    binding: .constant(.init()),
                    config: .init(),
                    constants: constants
                )
                Spacer()
                bottomCta
            }
        }

        // MARK: - Ghost Podium

        private var ghostPodium: some View {
            HStack(alignment: .bottom, spacing: 0) {
                ghostSpot(rank: 2, size: 44)
                    .frame(maxWidth: .infinity)
                ghostSpot(rank: 1, size: 56)
                    .frame(maxWidth: .infinity)
                ghostSpot(rank: 3, size: 44)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, constants.podiumHorizontalPadding)
            .padding(.top, constants.podiumTopPadding)
            .padding(.bottom, 10)
        }

        private func ghostSpot(rank: Int, size: CGFloat) -> some View {
            let color = ghostColor(rank: rank)

            return VStack(spacing: 0) {
                if rank == 1 { ghostCrown }

                ghostAvatar(size: size, color: color)

                ghostRibbon(rank: rank, color: color)
                    .padding(.top, 4)

                ghostBars(isFirst: rank == 1)
                    .padding(.top, 6)
            }
            .padding(.top, rank == 1 ? 0 : 16)
        }

        // MARK: - Ghost Avatar

        private func ghostAvatar(size: CGFloat, color: Color) -> some View {
            Circle()
                .strokeBorder(
                    style: StrokeStyle(lineWidth: 1.5, dash: [4, 3])
                )
                .foregroundStyle(color.opacity(0.6))
                .frame(width: size, height: size)
                .overlay(
                    Text("?")
                        .font(.system(
                            size: size == 56 ? 20 : 16,
                            weight: .semibold
                        ))
                        .foregroundStyle(color.opacity(0.7))
                )
        }

        // MARK: - Ghost Crown

        private var ghostCrown: some View {
            Image(systemName: "crown.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 17)
                .foregroundStyle(TapZeroDesign.Medal.gold)
                .opacity(0.35)
                .padding(.bottom, 4)
        }

        // MARK: - Ghost Ribbon

        private func ghostRibbon(rank: Int, color: Color) -> some View {
            let text: String = switch rank {
            case 1: TextKey.LeaderBoard.rankFirst
            case 2: TextKey.LeaderBoard.rankSecond
            default: TextKey.LeaderBoard.rankThird
            }

            return Text(text)
                .font(.system(size: 8, weight: .heavy))
                .foregroundStyle(rank == 3
                    ? Color(hex: TapZeroPalette.Neutral.N50)
                    : TapZeroDesign.Foreground.primary
                )
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(color)
                .clipShape(Capsule())
                .opacity(0.3)
        }

        // MARK: - Ghost Bars

        private func ghostBars(isFirst: Bool) -> some View {
            VStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(TapZeroDesign.Foreground.tertiary.opacity(0.15))
                    .frame(width: isFirst ? 40 : 32, height: 6)

                RoundedRectangle(cornerRadius: 2.5)
                    .fill(TapZeroDesign.Foreground.tertiary.opacity(0.1))
                    .frame(width: isFirst ? 28 : 22, height: 5)
            }
        }

        // MARK: - Bottom CTA

        private var bottomCta: some View {
            VStack(spacing: 4) {
                Text(config.headline)
                    .font(.system(size: 16, weight: .bold))
                    .tracking(-0.3)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)

                Text(config.subtitle)
                    .font(.system(size: 13))
                    .tracking(-0.1)
                    .lineSpacing(2)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
                    .multilineTextAlignment(.center)

                Button {
                    onAction(.didTapPlayGame)
                } label: {
                    Text(TextKey.LeaderBoard.lockedCta)
                        .font(TapZeroTypography.Label.button)
                        .tracking(-0.2)
                        .foregroundStyle(TapZeroDesign.Button.primaryForeground)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(TapZeroDesign.Button.primaryBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.top, 12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }

        // MARK: - Helpers

        private func ghostColor(rank: Int) -> Color {
            switch rank {
            case 1: TapZeroDesign.Medal.gold
            case 2: TapZeroDesign.Medal.silver
            default: TapZeroDesign.Medal.bronze
            }
        }
    }
}

// MARK: - Previews

private struct EmptyStatePreview: View {
    let headline: LocalizedStringKey
    let subtitle: LocalizedStringKey

    @State private var entity: LeaderBoardScreen.EmptyStateEntity

    init(
        headline: LocalizedStringKey,
        subtitle: LocalizedStringKey
    ) {
        self.headline = headline
        self.subtitle = subtitle
        _entity = State(initialValue: .init(
            binding: .init(),
            config: .init(headline: headline, subtitle: subtitle)
        ))
    }

    var body: some View {
        ZStack {
            TapZeroDesign.Background.primary.ignoresSafeArea()
            LeaderBoardScreen.EmptyStateView(
                binding: $entity.binding,
                config: entity.config,
                constants: .init()
            ) { _ in }
        }
    }
}

#Preview("6.5 — Global Empty") {
    EmptyStatePreview(
        headline: TextKey.LeaderBoard.emptyGlobalTitle,
        subtitle: TextKey.LeaderBoard.emptyGlobalSubtitle
    )
}

#Preview("6.6 — Daily Empty") {
    EmptyStatePreview(
        headline: TextKey.LeaderBoard.emptyDailyTitle,
        subtitle: TextKey.LeaderBoard.emptyDailySubtitle
    )
}
