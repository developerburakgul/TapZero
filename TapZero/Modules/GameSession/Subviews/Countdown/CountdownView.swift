//
//  CountdownView.swift
//  TapZero
//

import SwiftUI

extension GameSessionScreen {
    struct CountdownView: View, Equatable {
        let config: CountdownEntity.Config
        let constants: Constants

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config
        }

        var body: some View {
            ZStack {
                TapZeroDesign.Background.primary.ignoresSafeArea()

                concentricRings

                countdownText
            }
        }

        // MARK: - Rings

        private var concentricRings: some View {
            ZStack {
                Circle()
                    .stroke(
                        TapZeroDesign.Foreground.primary
                            .opacity(constants.outerRingOpacity),
                        lineWidth: constants.ringStrokeWidth
                    )
                    .frame(
                        width: constants.outerRingSize,
                        height: constants.outerRingSize
                    )

                Circle()
                    .stroke(
                        TapZeroDesign.Foreground.primary
                            .opacity(constants.innerRingOpacity),
                        lineWidth: constants.ringStrokeWidth
                    )
                    .frame(
                        width: constants.innerRingSize,
                        height: constants.innerRingSize
                    )
            }
        }

        // MARK: - Text

        private var countdownText: some View {
            Group {
                if config.showGo {
                    Text(TextKey.GameSession.go)
                        .font(TapZeroTypography.Display.countdownGo)
                        .tracking(constants.goTracking)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Text(TextKey.number(config.countdownValue))
                        .font(TapZeroTypography.Display.countdown)
                        .tracking(constants.countdownTracking)
                        .monospacedDigit()
                        .transition(.scale.combined(with: .opacity))
                        .id(config.countdownValue)
                }
            }
            .foregroundStyle(TapZeroDesign.Foreground.primary)
            .animation(.easeInOut(duration: 0.3), value: config.countdownValue)
            .animation(.easeInOut(duration: 0.2), value: config.showGo)
        }
    }
}
