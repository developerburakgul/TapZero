//
//  PodiumView.swift
//  TapZero
//

import SwiftUI

extension LeaderBoardScreen {
    struct PodiumView: View, Equatable {
        @Binding var binding: PodiumEntity.Binding
        let config: PodiumEntity.Config
        let constants: Constants

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config
        }

        var body: some View {
            HStack(alignment: .bottom, spacing: 0) {
                // 2nd place (left)
                secondPlace.frame(maxWidth: .infinity)
                // 1st place (center)
                firstPlace.frame(maxWidth: .infinity)
                // 3rd place (right)
                thirdPlace.frame(maxWidth: .infinity)
            }
            .padding(.horizontal, constants.podiumHorizontalPadding)
            .padding(.top, constants.podiumTopPadding)
            .padding(.bottom, constants.podiumBottomPadding)
        }

        private func entry(at index: Int) -> PodiumEntity.PodiumEntry? {
            index < config.entries.count ? config.entries[index] : nil
        }

        @ViewBuilder
        private var firstPlace: some View {
            if let first = entry(at: 0) {
                podiumColumn(entry: first, isFirst: true)
            } else {
                ghostSpot(rank: 1, size: constants.podiumFirstAvatarSize)
            }
        }

        @ViewBuilder
        private var secondPlace: some View {
            if let second = entry(at: 1) {
                podiumColumn(entry: second, isFirst: false)
            } else {
                ghostSpot(rank: 2, size: constants.podiumOtherAvatarSize)
            }
        }

        @ViewBuilder
        private var thirdPlace: some View {
            if let third = entry(at: 2) {
                podiumColumn(entry: third, isFirst: false)
            } else {
                ghostSpot(rank: 3, size: constants.podiumOtherAvatarSize)
            }
        }

        // MARK: - Podium Column

        private func podiumColumn(
            entry: PodiumEntity.PodiumEntry,
            isFirst: Bool
        ) -> some View {
            VStack(spacing: 0) {
                if isFirst {
                    crownView
                        .padding(.bottom, 4)
                }

                avatarSection(entry: entry, isFirst: isFirst)

                Text(entry.name)
                    .font(.system(
                        size: isFirst
                            ? constants.podiumFirstNameSize
                            : constants.podiumOtherNameSize,
                        weight: .bold
                    ))
                    .tracking(-0.2)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: constants.podiumNameMaxWidth)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
                    .padding(.top, constants.podiumAvatarToNameSpacing + 6)

                Text("\(entry.score)")
                    .font(.system(size: constants.podiumPointsSize, weight: .semibold))
                    .tracking(-0.3)
                    .monospacedDigit()
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
                    .padding(.top, constants.podiumNameToPointsSpacing)
            }
            .padding(.top, isFirst ? 0 : constants.podiumOtherTopOffset)
        }

        // MARK: - Avatar Section

        private func avatarSection(
            entry: PodiumEntity.PodiumEntry,
            isFirst: Bool
        ) -> some View {
            let size = isFirst
                ? constants.podiumFirstAvatarSize
                : constants.podiumOtherAvatarSize

            return ZStack(alignment: .bottom) {
                avatarImage(entry: entry, size: size)
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(entry.medalColor, lineWidth: constants.podiumAvatarBorderWidth)
                    )

                ribbonView(entry: entry)
                    .offset(y: -constants.podiumRibbonOverlap)
            }
        }

        private func avatarImage(
            entry: PodiumEntity.PodiumEntry,
            size: CGFloat
        ) -> some View {
            Group {
                if let urlString = entry.avatarURL, let url = URL(string: urlString) {
                    CachedAsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        monogramView(entry: entry, size: size)
                    }
                } else {
                    monogramView(entry: entry, size: size)
                }
            }
        }

        private func monogramView(
            entry: PodiumEntity.PodiumEntry,
            size: CGFloat
        ) -> some View {
            InitialAvatarView(
                initial: entry.initials,
                size: size
            )
        }

        // MARK: - Ghost Spot (empty slot)

        private func ghostSpot(rank: Int, size: CGFloat) -> some View {
            let color = ghostColor(rank: rank)
            return VStack(spacing: 0) {
                if rank == 1 { ghostCrown }

                Circle()
                    .strokeBorder(
                        style: StrokeStyle(lineWidth: 1.5, dash: [4, 3])
                    )
                    .foregroundStyle(color.opacity(0.6))
                    .frame(width: size, height: size)
                    .overlay(
                        Text("?")
                            .font(.system(size: size * 0.36, weight: .semibold))
                            .foregroundStyle(color.opacity(0.7))
                    )

                ghostRibbon(rank: rank, color: color)
                    .padding(.top, 4)

                ghostBars(isFirst: rank == 1)
                    .padding(.top, 6)
            }
            .padding(.top, rank == 1 ? 0 : constants.podiumOtherTopOffset)
        }

        private var ghostCrown: some View {
            Image(systemName: "crown.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 17)
                .foregroundStyle(TapZeroDesign.Medal.gold)
                .opacity(0.35)
                .padding(.bottom, 4)
        }

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

        private func ghostColor(rank: Int) -> Color {
            switch rank {
            case 1: TapZeroDesign.Medal.gold
            case 2: TapZeroDesign.Medal.silver
            default: TapZeroDesign.Medal.bronze
            }
        }

        // MARK: - Crown (1st place only)

        private var crownView: some View {
            Image(systemName: "crown.fill")
                .resizable()
                .scaledToFit()
                .frame(width: constants.podiumCrownWidth, height: constants.podiumCrownHeight)
                .foregroundStyle(TapZeroDesign.Medal.gold)
                .shadow(color: TapZeroDesign.Medal.goldAccent.opacity(0.4), radius: 2, y: 1)
        }

        // MARK: - Ribbon

        private func ribbonView(entry: PodiumEntity.PodiumEntry) -> some View {
            let rankText: String = switch entry.rank {
            case 1: TextKey.LeaderBoard.rankFirst
            case 2: TextKey.LeaderBoard.rankSecond
            case 3: TextKey.LeaderBoard.rankThird
            default: "\(entry.rank)"
            }

            return Text(rankText)
                .font(.system(size: 11, weight: .heavy))
                .tracking(-0.1)
                .foregroundStyle(entry.ribbonTextColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(entry.medalColor)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.1), radius: 1, y: 1)
        }
    }
}

// MARK: - Previews

private struct PodiumPreview: View {
    let names: [(String, Int)]

    @State private var entity: LeaderBoardScreen.PodiumEntity = .init(
        binding: .init(), config: .init(entries: [])
    )

    var body: some View {
        LeaderBoardScreen.PodiumView(
            binding: $entity.binding,
            config: entity.config,
            constants: .init()
        )
        .background(TapZeroDesign.Background.primary)
        .onAppear { buildEntries() }
    }

    private func buildEntries() {
        entity.config = .init(entries: names.enumerated().map { idx, pair in
            let rank = idx + 1
            let medal: Color = switch rank {
            case 1: TapZeroDesign.Medal.gold
            case 2: TapZeroDesign.Medal.silver
            default: TapZeroDesign.Medal.bronze
            }
            let ribbon: Color = rank == 3
                ? Color(hex: TapZeroPalette.Neutral.N50)
                : TapZeroDesign.Foreground.primary
            let pastel = TapZeroPalette.Pastel.all[
                rank % TapZeroPalette.Pastel.all.count
            ]
            return .init(
                rank: rank, name: pair.0, score: pair.1,
                avatarURL: nil, avatarColor: Color(hex: pastel),
                medalColor: medal, ribbonTextColor: ribbon
            )
        })
    }
}

#Preview("Top Players — High Scores") {
    PodiumPreview(names: [
        ("Mira Stone", 984),
        ("Kenji Park", 971),
        ("Yuna Choi", 958)
    ])
}

#Preview("Close Competition") {
    PodiumPreview(names: [
        ("Noah Kim", 952),
        ("Sofia Rossi", 950),
        ("Liam Carter", 949)
    ])
}

#Preview("Long Names") {
    PodiumPreview(names: [
        ("Alexander Hamilton III", 997),
        ("Elizabeth Bennet-Darcy", 985),
        ("Jean-Pierre Dubois", 963)
    ])
}

#Preview("1 Player — Ghost 2nd & 3rd") {
    PodiumPreview(names: [
        ("Burak", 920)
    ])
}

#Preview("2 Players — Ghost 3rd") {
    PodiumPreview(names: [
        ("Mira Stone", 984),
        ("Burak", 920)
    ])
}
