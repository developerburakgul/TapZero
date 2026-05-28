//
//  YourSpotRowView.swift
//  TapZero
//

import SwiftUI

extension LeaderBoardScreen {
    struct YourSpotRowView: View, Equatable {
        @Binding var binding: YourSpotRowEntity.Binding
        let config: YourSpotRowEntity.Config
        private let constants = Constants()

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config
        }

        var body: some View {
            HStack(spacing: constants.gap) {
                Text("?")
                    .font(.system(size: 13, weight: .bold))
                    .frame(minWidth: constants.rankWidth, alignment: .center)
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)

                Circle()
                    .strokeBorder(
                        style: StrokeStyle(lineWidth: 1.5, dash: [4, 3])
                    )
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)
                    .frame(width: constants.avatarSize, height: constants.avatarSize)

                Text(TextKey.LeaderBoard.yourSpotWaiting)
                    .font(.system(size: 15, weight: .medium))
                    .italic()
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)

                Spacer()

                Text("—")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)
            }
            .padding(.horizontal, constants.paddingH)
            .padding(.vertical, constants.paddingV)
            .overlay(
                RoundedRectangle(cornerRadius: constants.cornerRadius)
                    .strokeBorder(
                        style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])
                    )
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)
                    .opacity(0.5)
            )
            .padding(.horizontal, constants.horizontalPadding)
        }
    }
}

// MARK: - Previews

private struct YourSpotPreview: View {
    @State private var entity: LeaderBoardScreen.YourSpotRowEntity = .init(
        binding: .init(), config: .init()
    )

    var body: some View {
        LeaderBoardScreen.YourSpotRowView(
            binding: $entity.binding,
            config: entity.config
        )
        .background(TapZeroDesign.Background.primary)
    }
}

#Preview("Your Spot Row") {
    YourSpotPreview()
}
