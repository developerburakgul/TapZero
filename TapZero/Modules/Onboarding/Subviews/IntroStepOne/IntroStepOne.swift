//
//  IntroStepOne.swift
//  TapZero
//

import SwiftUI

extension OnboardingScreen {
    struct IntroStepOne: View, @MainActor Equatable {
        @Binding var binding: IntroStepOneEntity.Binding
        let config: IntroStepOneEntity.Config

        var body: some View {
            VStack(spacing: 0) {
                // Hero ring — centered, flex
                heroRing
                    .frame(maxHeight: .infinity)

                // Copy — bottom
                copySection
            }
            .padding(.horizontal, 28)
        }

        // MARK: - Hero Ring

        private var heroRing: some View {
            ZStack {
                ringBase
                orbitHint
                orbitDot
            }
            .frame(width: 240, height: 240)
        }

        private var ringBase: some View {
            ZStack {
                // Outer ring
                Circle()
                    .stroke(TapZeroDesign.Foreground.primary, lineWidth: 1.5)

                // Inner ring (inset 56 → 240 - 2*56 = 128)
                Circle()
                    .stroke(TapZeroDesign.Foreground.primary.opacity(0.35), lineWidth: 1.5)
                    .frame(width: 128, height: 128)

                // Center dot
                Circle()
                    .fill(TapZeroDesign.Foreground.primary)
                    .frame(width: 10, height: 10)
            }
        }

        // Dashed orbit hint — from 12 o'clock CW to ~2 o'clock
        private var orbitHint: some View {
            // SVG path: M120,5 A115,115 0 0 1 220,80
            // Arc radius 115, from top-center to right-upper area (~80°)
            Circle()
                .trim(from: 0, to: 0.22)
                .stroke(
                    TapZeroDesign.Foreground.primary.opacity(0.35),
                    style: StrokeStyle(lineWidth: 1.2, dash: [2, 4])
                )
                .frame(width: 230, height: 230)
                .rotationEffect(.degrees(-90))
        }

        // Green dot frozen at 12 o'clock — bg gap + subtle green outer ring
        private var orbitDot: some View {
            ZStack {
                Circle()
                    .stroke(TapZeroDesign.Status.good.opacity(0.2), lineWidth: 1)
                    .frame(width: 20, height: 20)

                Circle()
                    .fill(TapZeroDesign.Background.primary)
                    .frame(width: 18, height: 18)

                Circle()
                    .fill(TapZeroDesign.Status.good)
                    .frame(width: 10, height: 10)
            }
            .offset(y: -120)
        }

        // MARK: - Copy

        private var copySection: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text(config.title)
                    .font(TapZeroTypography.Heading.pageHeader)
                    .tracking(-0.9)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)

                Text(config.subtitle)
                    .font(TapZeroTypography.Body.primary)
                    .tracking(-0.1)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 24)
            .padding(.bottom, 12)
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.binding == rhs.binding && lhs.config == rhs.config
        }
    }
}
