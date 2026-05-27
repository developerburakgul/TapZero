//
//  PlayScreen.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

struct PlayScreen: View {
    // MARK: - Private properties
    private let constants = Constants()

    // MARK: - Observed properties
    @StateObject var viewModel: PlayViewModel

    var body: some View {
        contentView
            .task {
                if !viewModel.didAppearOnce {
                    viewModel.didAppearOnce = true
                    await viewModel.viewDidLoad()
                }
                await viewModel.viewWillAppear()
            }
    }

    private var contentView: some View {
        ZStack {
            TapZeroDesign.Background.primary.ignoresSafeArea()

            VStack(spacing: 0) {
                UserStrip(
                    config: .init(
                        initial: viewModel.userInitial,
                        displayName: viewModel.userName,
                        bestScore: viewModel.bestScore,
                        avatarColor: viewModel.avatarColor,
                        profileImageURL: viewModel.profileImageURL
                    )
                )

                centerStack

                PlayButton(
                    config: .init(buttonLabel: TextKey.Play.playButton)
                ) { action in
                    switch action {
                    case .didTapPlay:
                        viewModel.onPlayTapped()
                    }
                }
            }
        }
    }

    // MARK: - Center Stack

    private var centerStack: some View {
        VStack(spacing: 0) {
            Spacer()

            targetLabel
                .padding(.bottom, 18)

            NumberPicker(
                selectedTarget: $viewModel.selectedTarget,
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
        Text(TextKey.Play.seconds)
            .font(TapZeroTypography.Body.medium)
            .foregroundStyle(TapZeroDesign.Foreground.secondary)
    }

    private var swipeHint: some View {
        Text(TextKey.Play.swipeToSelect)
            .font(TapZeroTypography.Caption.helper)
            .tracking(0.1)
            .foregroundStyle(TapZeroDesign.Foreground.tertiary)
    }
}

#Preview {
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    RouterView(id: "play", addModuleSupport: true) { router in
        PlayBuilder.build(router: router)
    }
    .environment(\.locale, DevPreview.shared.locale)
}
