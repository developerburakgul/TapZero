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
            Circle()
                .fill(config.avatarColor.opacity(0.15))
                .frame(width: 34, height: 34)
                .overlay(
                    Text(config.initial)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(config.avatarColor)
                )
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

                Text("\(score)")
                    .font(.system(size: 15, weight: .semibold).monospacedDigit())
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
            }
        }
    }
}
