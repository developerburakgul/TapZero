//
//  PlayButton.swift
//  TapZero
//

import SwiftUI

extension PlayScreen {
    struct PlayButton: View {
        enum Action {
            case didTapPlay
        }

        let config: PlayButtonEntity.Config
        let onAction: (Action) -> Void

        var body: some View {
            Button {
                onAction(.didTapPlay)
            } label: {
                Text(config.buttonLabel)
                    .font(TapZeroTypography.Label.button)
                    .tracking(-0.2)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(TapZeroDesign.Button.primaryBackground)
                    .foregroundStyle(TapZeroDesign.Button.primaryForeground)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(
                        color: TapZeroDesign.Foreground.primary.opacity(0.12),
                        radius: 10,
                        y: 6
                    )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
    }
}
