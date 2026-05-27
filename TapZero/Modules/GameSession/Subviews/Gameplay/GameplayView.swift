//
//  GameplayView.swift
//  TapZero
//

import SwiftUI

extension GameSessionScreen {
    struct GameplayView: View, Equatable {
        let config: GameplayEntity.Config
        let constants: Constants

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.config == rhs.config
        }

        var body: some View {
            ZStack {
                TapZeroDesign.Background.primary.ignoresSafeArea()

                targetIndicator

                if config.showRipple, let position = config.tapPosition {
                    rippleEffect(at: position)
                }

                hintLabel
            }
        }

        // MARK: - Target Indicator

        private var targetIndicator: some View {
            VStack(spacing: 6) {
                Text(TextKey.GameSession.targetLabel)
                    .font(.system(size: 12, weight: .semibold))
                    .tracking(constants.targetLabelTracking)
                    .textCase(.uppercase)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)

                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(config.targetTimeFormatted)
                        .font(
                            .system(
                                size: constants.targetValueSize,
                                weight: .bold
                            )
                        )
                        .tracking(constants.targetValueTracking)
                        .monospacedDigit()
                        .foregroundStyle(TapZeroDesign.Foreground.primary)

                    Text("s")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(TapZeroDesign.Foreground.secondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, constants.targetTopPadding)
        }

        // MARK: - Ripple

        private func rippleEffect(at position: CGPoint) -> some View {
            ZStack {
                Circle()
                    .fill(TapZeroDesign.Foreground.primary)
                    .frame(
                        width: constants.rippleDotSize,
                        height: constants.rippleDotSize
                    )

                RippleRing(
                    size: constants.rippleInnerRingSize,
                    show: config.showRipple
                )

                RippleRing(
                    size: constants.rippleOuterRingSize,
                    show: config.showRipple
                )
            }
            .position(position)
        }

        // MARK: - Hint

        private var hintLabel: some View {
            Text(TextKey.GameSession.tapHint)
                .font(.system(size: 12, weight: .regular))
                .tracking(constants.hintTracking)
                .foregroundStyle(TapZeroDesign.Foreground.tertiary)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, constants.hintBottomPadding)
        }
    }
}

// MARK: - Ripple Ring

private struct RippleRing: View {
    let size: CGFloat
    let show: Bool

    @State private var scale: CGFloat = 0
    @State private var opacity: Double = 0.4

    var body: some View {
        Circle()
            .stroke(TapZeroDesign.Foreground.primary, lineWidth: 1)
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .opacity(opacity)
            .onChange(of: show) { _, newValue in
                if newValue {
                    scale = 0
                    opacity = 0.4
                    withAnimation(.easeOut(duration: 0.6)) {
                        scale = 1
                        opacity = 0
                    }
                }
            }
    }
}
