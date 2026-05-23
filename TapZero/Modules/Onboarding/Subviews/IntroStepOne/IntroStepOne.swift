//
//  IntroStepOne.swift
//  TapZero
//

import SwiftUI

extension OnboardingScreen {
    struct IntroStepOne: View, @MainActor Equatable {
        enum Action {
            case didTapContinue
        }

        @Binding var binding: IntroStepOneEntity.Binding
        let config: IntroStepOneEntity.Config
        let onAction: (Action) -> Void

        @State private var showIcons: Bool = false
        @State private var showContent: Bool = false
        @State private var floatPhase: Bool = false

        var body: some View {
            VStack(spacing: 0) {
                Spacer()
                iconGrid
                textSection
                Spacer()
                continueButton
            }
            .padding(.horizontal, 24)
            .onAppear { runAnimations() }
        }

        // MARK: - Icon Grid

        private var iconGrid: some View {
            let icons: [(String, Color)] = [
                ("star.fill", TapZeroDesign.System.systemYellow),
                ("heart.fill", TapZeroDesign.System.systemRed),
                ("bolt.fill", TapZeroDesign.System.systemBlue),
                ("flame.fill", TapZeroDesign.System.systemOrange),
                ("sparkles", TapZeroDesign.Accent.primary),
                ("globe", TapZeroDesign.System.systemGreen),
                ("bell.fill", TapZeroDesign.Accent.secondary),
                ("person.fill", TapZeroDesign.System.systemPink),
                ("shield.fill", TapZeroDesign.System.systemTeal)
            ]

            return LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3),
                spacing: 16
            ) {
                ForEach(Array(icons.enumerated()), id: \.offset) { index, icon in
                    iconBubble(symbol: icon.0, color: icon.1, index: index)
                }
            }
            .frame(maxWidth: 280)
        }

        private func iconBubble(symbol: String, color: Color, index: Int) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(color.opacity(0.12))
                    .frame(width: 72, height: 72)

                Image(systemName: symbol)
                    .font(.system(size: 28))
                    .foregroundStyle(color)
            }
            .scaleEffect(showIcons ? 1.0 : 0.01)
            .opacity(showIcons ? 1 : 0)
            .offset(y: floatPhase ? -4 : 4)
            .animation(
                .easeInOut(duration: Double.random(in: 1.8...2.4))
                .repeatForever(autoreverses: true)
                .delay(Double(index) * 0.1),
                value: floatPhase
            )
        }

        // MARK: - Text

        private var textSection: some View {
            VStack(spacing: 8) {
                Text(config.title)
                    .font(TapZeroTypography.Display.medium)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
                    .multilineTextAlignment(.center)

                Text(config.subtitle)
                    .font(TapZeroTypography.Body.medium)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)
        }

        // MARK: - Button

        private var continueButton: some View {
            Button {
                onAction(.didTapContinue)
            } label: {
                Text(TextKey.Onboarding.continueButton)
                    .font(TapZeroTypography.Label.large)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(TapZeroDesign.Foreground.primary)
                    .foregroundStyle(TapZeroDesign.Background.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.bottom, 16)
            .opacity(showContent ? 1 : 0)
        }

        // MARK: - Animation

        private func runAnimations() {
            showIcons = false
            showContent = false
            floatPhase = false

            withAnimation(.spring(duration: 0.6, bounce: 0.4).delay(0.2)) {
                showIcons = true
            }

            withAnimation(.easeOut(duration: 0.4).delay(0.7)) {
                showContent = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                floatPhase = true
            }
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.binding == rhs.binding
            && lhs.config == rhs.config
        }
    }
}
