//
//  IntroStepOne.swift
//  TapZero
//

import DynamicColor
import SwiftUI

extension OnboardingScreen {
    struct IntroStepOne: View, @MainActor Equatable {
        @Binding var binding: IntroStepOneEntity.Binding
        let config: IntroStepOneEntity.Config
        @ObservedObject private var themeStore = ThemeStore.shared

        var body: some View {
            VStack(spacing: 0) {
                appIcon
                    .frame(maxHeight: .infinity)

                copySection
            }
            .padding(.horizontal, 28)
        }

        // MARK: - App Icon

        private var appIcon: some View {
            let isDark = themeStore.theme == .dark
                || (themeStore.theme == .system
                    && UITraitCollection.current.userInterfaceStyle == .dark)
            return Image(isDark ? "tapzero-icon-tap-white" : "tapzero-icon-tap-black")
                .resizable()
                .scaledToFit()
                .frame(width: 128, height: 128)
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
