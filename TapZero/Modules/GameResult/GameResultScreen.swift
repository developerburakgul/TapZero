//
//  GameResultScreen.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

struct GameResultScreen: View {
    // MARK: - Private properties
    private let constants = Constants()

    // MARK: - Observed properties
    @StateObject var viewModel: GameResultViewModel

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
        VStack(spacing: 0) {
            sheetHeader
                .padding(.horizontal, constants.sheetPadding)
                .padding(.top, 14)

            scoreCard
                .padding(.horizontal, constants.sheetPadding)
                .padding(.top, 14)

            Spacer()

            playAgainButton
                .padding(.horizontal, constants.sheetPadding)
                .padding(.bottom, 16)
        }
        .background(TapZeroDesign.Background.primary)
    }

    // MARK: - Header

    private var sheetHeader: some View {
        HStack {
            closeButton
            Spacer()
            shareButton
        }
    }

    private var closeButton: some View {
        Button {
            viewModel.onCloseTapped()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(TapZeroDesign.Foreground.primary)
                .frame(
                    width: constants.headerIconSize,
                    height: constants.headerIconSize
                )
                .background(TapZeroDesign.Background.secondary)
                .clipShape(Circle())
        }
    }

    private var shareButton: some View {
        Button {
            viewModel.onShareTapped()
        } label: {
            HStack(spacing: 7) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 14, weight: .semibold))

                Text(TextKey.GameResult.share)
                    .font(.system(size: 14, weight: .semibold))
                    .tracking(-0.2)
            }
            .foregroundStyle(TapZeroDesign.Button.primaryForeground)
            .padding(.horizontal, 16)
            .frame(height: constants.headerIconSize)
            .background(TapZeroDesign.Button.primaryBackground)
            .clipShape(Capsule())
        }
    }

    // MARK: - Score Card

    private var scoreCard: some View {
        ScoreCardView(
            config: .init(
                score: viewModel.score,
                scoreColor: viewModel.scoreColor,
                offLabelText: viewModel.offLabelText,
                offPillBackground: viewModel.offPillBackground,
                isPerfect: viewModel.entity.performanceRating == .perfect,
                targetTimeFormatted: viewModel.targetTimeFormatted,
                tappedTimeFormatted: viewModel.tappedTimeFormatted,
                timelineUserOffset: viewModel.timelineUserOffset,
                targetSeconds: viewModel.entity.targetSeconds
            ),
            constants: constants
        )
    }

    // MARK: - Play Again

    private var playAgainButton: some View {
        Button {
            viewModel.onPlayAgainTapped()
        } label: {
            Text(TextKey.GameResult.playAgain)
                .font(TapZeroTypography.Label.button)
                .tracking(-0.2)
                .frame(maxWidth: .infinity)
                .frame(height: constants.playAgainHeight)
                .background(TapZeroDesign.Button.primaryBackground)
                .foregroundStyle(TapZeroDesign.Button.primaryForeground)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: constants.playAgainCornerRadius
                    )
                )
        }
    }
}

#Preview {
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    RouterView(id: "gameResult", addModuleSupport: true) { router in
        GameResultBuilder.build(
            router: router,
            entity: GameResultEntity(
                score: 847,
                targetSeconds: 5,
                tappedSeconds: 5.08,
                delta: 0.08,
                performanceRating: .good
            )
        ) {}
    }
    .environment(\.locale, DevPreview.shared.locale)
}
