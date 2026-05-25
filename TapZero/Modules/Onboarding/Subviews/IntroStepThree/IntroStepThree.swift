//
//  IntroStepThree.swift
//  TapZero
//

import SwiftUI

extension OnboardingScreen {
    private struct PreviewUser: Identifiable {
        let id: Int
        let name: String
        let pts: Int
        let color: String

        var rank: Int { id }
    }

    struct IntroStepThree: View, @MainActor Equatable {
        @Binding var binding: IntroStepThreeEntity.Binding
        let config: IntroStepThreeEntity.Config

        @State private var headerOpacity: Double = 0
        @State private var podiumScale: CGFloat = 0.9
        @State private var podiumOpacity: Double = 0
        @State private var listOpacity: Double = 0

        private static let podiumUsers: [PreviewUser] = [
            .init(id: 2, name: "Kenji", pts: 9710, color: TapZeroPalette.Pastel.PS2),
            .init(id: 1, name: "Mira", pts: 9842, color: TapZeroPalette.Pastel.PS1),
            .init(id: 3, name: "Yuna", pts: 9588, color: TapZeroPalette.Pastel.PS3)
        ]

        private static let listUsers: [PreviewUser] = [
            .init(id: 4, name: "Aaron West", pts: 9421, color: TapZeroPalette.Pastel.PS4),
            .init(id: 5, name: "Léa Marchand", pts: 9344, color: TapZeroPalette.Pastel.PS5)
        ]

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                headerSection
                podiumSection
                listSection
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

        // MARK: - Podium

        private var podiumSection: some View {
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(Self.podiumUsers) { user in
                    podiumItem(user: user)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 24)
            .opacity(podiumOpacity)
            .scaleEffect(podiumScale)
        }

        private func podiumItem(user: PreviewUser) -> some View {
            let isBig = user.rank == 1
            let size: CGFloat = isBig ? 64 : 50

            return VStack(spacing: 0) {
                podiumAvatar(user: user, size: size, isBig: isBig)
                podiumLabel(user: user, isBig: isBig)
            }
        }

        private func podiumAvatar(
            user: PreviewUser,
            size: CGFloat,
            isBig: Bool
        ) -> some View {
            Circle()
                .fill(Color(hex: user.color))
                .frame(width: size - 6, height: size - 6)
                .overlay(
                    Circle()
                        .stroke(medalColor(for: user.rank), lineWidth: 2)
                        .frame(width: size, height: size)
                )
                .padding(.top, isBig ? 0 : 20)
        }

        private func podiumLabel(user: PreviewUser, isBig: Bool) -> some View {
            let ringColor = medalColor(for: user.rank)
            let badgeFg = user.rank == 3
                ? TapZeroDesign.Background.primary
                : TapZeroDesign.Foreground.primary

            return VStack(spacing: 0) {
                Text(rankLabel(user.rank))
                    .font(TapZeroTypography.Caption.rankBadge)
                    .tracking(-0.1)
                    .foregroundStyle(badgeFg)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(ringColor)
                    .clipShape(Capsule())
                    .offset(y: -6)

                Text(user.name)
                    .font(.system(size: isBig ? 13 : 12, weight: .bold))
                    .tracking(-0.2)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)

                Text(formattedPoints(user.pts))
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(-0.2)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
                    .monospacedDigit()
            }
        }

        // MARK: - List

        private var listSection: some View {
            VStack(spacing: 0) {
                ForEach(Self.listUsers) { user in
                    listRow(user: user)
                }

                yourSpotRow
            }
            .padding(.top, 6)
            .opacity(listOpacity)
        }

        private func listRow(user: PreviewUser) -> some View {
            HStack(spacing: 12) {
                Text("\(user.rank)")
                    .font(.system(size: 13, weight: .bold))
                    .tracking(-0.2)
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)
                    .frame(width: 22)

                Circle()
                    .fill(Color(hex: user.color))
                    .frame(width: 30, height: 30)

                Text(user.name)
                    .font(.system(size: 14, weight: .medium))
                    .tracking(-0.2)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)

                Spacer()

                Text(formattedPoints(user.pts))
                    .font(.system(size: 14, weight: .bold))
                    .tracking(-0.3)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
                    .monospacedDigit()
            }
            .padding(.vertical, 9)
            .padding(.horizontal, 4)
        }

        private var yourSpotRow: some View {
            HStack(spacing: 12) {
                Text("?")
                    .font(.system(size: 13, weight: .bold))
                    .tracking(-0.2)
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)
                    .frame(width: 22)

                Circle()
                    .strokeBorder(
                        TapZeroDesign.Foreground.tertiary,
                        style: StrokeStyle(lineWidth: 1, dash: [3, 3])
                    )
                    .frame(width: 30, height: 30)

                Text(TextKey.Onboarding.yourSpotWaiting)
                    .font(.system(size: 14, weight: .medium))
                    .tracking(-0.2)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
                    .italic()

                Spacer()

                Text("—")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)
            }
            .padding(.vertical, 9)
            .padding(.horizontal, 4)
            .opacity(0.5)
        }

        // MARK: - Helpers

        private func medalColor(for rank: Int) -> Color {
            switch rank {
            case 1: TapZeroDesign.Medal.gold
            case 2: TapZeroDesign.Medal.silver
            default: TapZeroDesign.Medal.bronze
            }
        }

        private func rankLabel(_ rank: Int) -> String {
            switch rank {
            case 1: "1st"
            case 2: "2nd"
            case 3: "3rd"
            default: "\(rank)th"
            }
        }

        private func formattedPoints(_ pts: Int) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: pts)) ?? "\(pts)"
        }

        // MARK: - Animation

        private func startAnimations() {
            withAnimation(.easeOut(duration: 0.4)) {
                headerOpacity = 1
            }
            withAnimation(.spring(duration: 0.6, bounce: 0.25).delay(0.2)) {
                podiumOpacity = 1
                podiumScale = 1
            }
            withAnimation(.easeOut(duration: 0.4).delay(0.5)) {
                listOpacity = 1
            }
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.binding == rhs.binding && lhs.config == rhs.config
        }
    }
}
