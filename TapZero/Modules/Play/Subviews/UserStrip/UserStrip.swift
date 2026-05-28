//
//  UserStrip.swift
//  TapZero
//

import SwiftUI

extension PlayScreen {
    struct UserStrip: View {
        let config: UserStripEntity.Config

        var body: some View {
            HStack {
                avatarView
                greetingView
                Spacer()
                if let score = config.bestScore {
                    bestScoreView(score)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
        }

        private var avatarView: some View {
            Group {
                if let url = config.profileImageURL {
                    CachedAsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        initialAvatar
                    }
                } else {
                    initialAvatar
                }
            }
            .frame(width: 34, height: 34)
            .clipShape(Circle())
        }

        private var initialAvatar: some View {
            InitialAvatarView(initial: config.initial, size: 34)
        }

        private var greetingView: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text(TextKey.Play.greeting)
                    .font(TapZeroTypography.Caption.small)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)

                Text(config.displayName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
            }
        }

        private func bestScoreView(_ score: Int) -> some View {
            VStack(alignment: .trailing, spacing: 0) {
                Text(TextKey.Play.bestLabel)
                    .font(TapZeroTypography.Caption.small)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)

                Text(TextKey.number(score))
                    .font(.system(size: 15, weight: .semibold).monospacedDigit())
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
            }
        }
    }
}
