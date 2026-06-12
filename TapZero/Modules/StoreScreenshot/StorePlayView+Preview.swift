//
//  StorePlayView+Preview.swift
//  TapZero
//

import SwiftUI

// MARK: - Play Screen Showcase

struct StorePlayShowcase: View {
    let localeData: StoreLocaleData

    private let constants = PlayScreen.Constants()
    @State private var selectedTarget = 5

    var body: some View {
        ZStack {
            TapZeroDesign.Background.primary.ignoresSafeArea()

            VStack(spacing: 0) {
                userStrip

                centerStack

                playButton
            }
        }
    }

    // MARK: - User Strip

    private var userStrip: some View {
        PlayScreen.UserStrip(
            config: .init(
                initial: String(localeData.userName.prefix(1)).uppercased(),
                displayName: localeData.userName,
                bestScore: 891,
                avatarColor: Color(hex: "#007AFF"),
                profileImageURL: nil
            )
        )
    }

    // MARK: - Center Stack

    private var centerStack: some View {
        VStack(spacing: 0) {
            Spacer()

            targetLabel
                .padding(.bottom, 18)

            PlayScreen.NumberPicker(
                selectedTarget: $selectedTarget,
                config: .init(
                    minTarget: constants.minTarget,
                    maxTarget: constants.maxTarget
                ),
                constants: constants
            )

            secondsLabel
                .padding(.top, 2)

            swipeHint
                .padding(.top, 28)

            Spacer()
        }
    }

    private var targetLabel: some View {
        Text(TextKey.Play.target)
            .font(TapZeroTypography.Caption.sectionHeader)
            .tracking(1.4)
            .foregroundStyle(TapZeroDesign.Foreground.secondary)
    }

    private var secondsLabel: some View {
        Text(TextKey.Play.secondsLabel(count: selectedTarget))
            .font(TapZeroTypography.Body.medium)
            .foregroundStyle(TapZeroDesign.Foreground.secondary)
    }

    private var swipeHint: some View {
        Text(TextKey.Play.swipeToSelect)
            .font(TapZeroTypography.Caption.helper)
            .tracking(0.1)
            .foregroundStyle(TapZeroDesign.Foreground.tertiary)
    }

    // MARK: - Play Button

    private var playButton: some View {
        PlayScreen.PlayButton(
            config: .init(buttonLabel: TextKey.Play.playButton)
        ) { _ in }
            .scaleEffect(1.05)
            .padding(.bottom, 4)
    }
}

// MARK: - Previews (10 Locales)

#Preview("Store Play — EN") {
    StoreLocalePreview(storeLocales[0]) { StorePlayShowcase(localeData: storeLocales[0]) }
}
#Preview("Store Play — DE") {
    StoreLocalePreview(storeLocales[1]) { StorePlayShowcase(localeData: storeLocales[1]) }
}
#Preview("Store Play — FR") {
    StoreLocalePreview(storeLocales[2]) { StorePlayShowcase(localeData: storeLocales[2]) }
}
#Preview("Store Play — ES") {
    StoreLocalePreview(storeLocales[3]) { StorePlayShowcase(localeData: storeLocales[3]) }
}
#Preview("Store Play — IT") {
    StoreLocalePreview(storeLocales[4]) { StorePlayShowcase(localeData: storeLocales[4]) }
}
#Preview("Store Play — JA") {
    StoreLocalePreview(storeLocales[5]) { StorePlayShowcase(localeData: storeLocales[5]) }
}
#Preview("Store Play — KO") {
    StoreLocalePreview(storeLocales[6]) { StorePlayShowcase(localeData: storeLocales[6]) }
}
#Preview("Store Play — TR") {
    StoreLocalePreview(storeLocales[7]) { StorePlayShowcase(localeData: storeLocales[7]) }
}
#Preview("Store Play — AR") {
    StoreLocalePreview(storeLocales[8]) { StorePlayShowcase(localeData: storeLocales[8]) }
}
#Preview("Store Play — PT-BR") {
    StoreLocalePreview(storeLocales[9]) { StorePlayShowcase(localeData: storeLocales[9]) }
}
