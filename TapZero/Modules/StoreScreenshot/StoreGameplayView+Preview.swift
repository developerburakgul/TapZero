//
//  StoreGameplayView+Preview.swift
//  TapZero
//

import SwiftUI

// MARK: - Countdown Step

private struct CountdownStep {
    let value: Int
    let opacity: Double
    let offsetX: CGFloat
    let offsetY: CGFloat
    let scale: CGFloat
}

private let countdownSteps: [CountdownStep] = [
    .init(value: 3, opacity: 0.10, offsetX: 0, offsetY: -180, scale: 0.55),
    .init(value: 2, opacity: 0.22, offsetX: 0, offsetY: -100, scale: 0.70),
    .init(value: 1, opacity: 0.40, offsetX: 0, offsetY: -40, scale: 0.85)
]

// MARK: - Gameplay Countdown Showcase

private struct StoreGameplayShowcase: View {
    let localeData: StoreLocaleData

    var body: some View {
        ZStack {
            TapZeroDesign.Background.primary.ignoresSafeArea()

            concentricRings

            countdownTrail
        }
    }

    // MARK: - Concentric Rings

    private var concentricRings: some View {
        ZStack {
            Circle()
                .stroke(
                    TapZeroDesign.Foreground.primary.opacity(0.22),
                    lineWidth: 1.5
                )
                .frame(width: 320, height: 320)

            Circle()
                .stroke(
                    TapZeroDesign.Foreground.primary.opacity(0.14),
                    lineWidth: 1.5
                )
                .frame(width: 220, height: 220)
        }
    }

    // MARK: - Countdown Motion Trail

    private var countdownTrail: some View {
        ZStack {
            ForEach(Array(countdownSteps.enumerated()), id: \.offset) { _, step in
                Text(TextKey.number(step.value))
                    .font(TapZeroTypography.Display.countdown)
                    .tracking(-10)
                    .monospacedDigit()
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
                    .opacity(step.opacity)
                    .offset(x: step.offsetX, y: step.offsetY)
                    .scaleEffect(step.scale)
            }

            // "GO" — hero
            Text(TextKey.GameSession.go)
                .font(TapZeroTypography.Display.countdownGo)
                .tracking(8)
                .foregroundStyle(TapZeroDesign.Foreground.primary)
                .scaleEffect(1.2)
        }
    }
}

// MARK: - Previews (10 Locales)

#Preview("Store Gameplay — EN") {
    StoreLocalePreview(storeLocales[0]) { StoreGameplayShowcase(localeData: storeLocales[0]) }
}
#Preview("Store Gameplay — TR") {
    StoreLocalePreview(storeLocales[1]) { StoreGameplayShowcase(localeData: storeLocales[1]) }
}
#Preview("Store Gameplay — AR") {
    StoreLocalePreview(storeLocales[2]) { StoreGameplayShowcase(localeData: storeLocales[2]) }
}
#Preview("Store Gameplay — DE") {
    StoreLocalePreview(storeLocales[3]) { StoreGameplayShowcase(localeData: storeLocales[3]) }
}
#Preview("Store Gameplay — ES") {
    StoreLocalePreview(storeLocales[4]) { StoreGameplayShowcase(localeData: storeLocales[4]) }
}
#Preview("Store Gameplay — FR") {
    StoreLocalePreview(storeLocales[5]) { StoreGameplayShowcase(localeData: storeLocales[5]) }
}
#Preview("Store Gameplay — IT") {
    StoreLocalePreview(storeLocales[6]) { StoreGameplayShowcase(localeData: storeLocales[6]) }
}
#Preview("Store Gameplay — JA") {
    StoreLocalePreview(storeLocales[7]) { StoreGameplayShowcase(localeData: storeLocales[7]) }
}
#Preview("Store Gameplay — KO") {
    StoreLocalePreview(storeLocales[8]) { StoreGameplayShowcase(localeData: storeLocales[8]) }
}
#Preview("Store Gameplay — PT-BR") {
    StoreLocalePreview(storeLocales[9]) { StoreGameplayShowcase(localeData: storeLocales[9]) }
}
