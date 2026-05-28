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
                if config.entries.count >= 3 {
                    podiumColumn(entry: config.entries[1], isFirst: false)
                        .frame(maxWidth: .infinity)

                    podiumColumn(entry: config.entries[0], isFirst: true)
                        .frame(maxWidth: .infinity)

                    podiumColumn(entry: config.entries[2], isFirst: false)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, constants.podiumHorizontalPadding)
            .padding(.top, constants.podiumTopPadding)
            .padding(.bottom, constants.podiumBottomPadding)
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
