//
//  SharePreviewScreen.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

struct SharePreviewScreen: View {
    // MARK: - Private properties
    private let constants = Constants()

    // MARK: - Observed properties
    @StateObject var viewModel: SharePreviewViewModel

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
            header
                .padding(.horizontal, 16)
                .padding(.top, 14)

            Spacer()

            shareableCard
                .padding(.horizontal, 20)

            Spacer()

            colorPicker
                .padding(.bottom, 20)

            shareButton
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
        }
        .background(TapZeroDesign.Background.primary.ignoresSafeArea())
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Button {
                viewModel.onCloseTapped()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
                    .frame(width: 36, height: 36)
                    .background(TapZeroDesign.Background.secondary)
                    .clipShape(Circle())
            }
            Spacer()
        }
    }

    // MARK: - Shareable Card

    private var shareableCard: some View {
        cardContent
    }

    private var cardContent: some View {
        GameResultScreen.ScoreCardView(
            config: .init(
                score: viewModel.score,
                scoreColor: viewModel.scoreColor,
                offLabelText: viewModel.offLabelText,
                offPillBackground: viewModel.offPillBackground,
                isPerfect: viewModel.entity.performanceRating == .perfect,
                targetTimeFormatted: viewModel.targetTimeFormatted,
                tappedTimeFormatted: viewModel.tappedTimeFormatted,
                timelineUserOffset: viewModel.timelineUserOffset,
                targetSeconds: viewModel.entity.targetSeconds,
                isCompact: true,
                cardBackground: viewModel.selectedColor
            ),
            constants: GameResultScreen.Constants()
        )
    }

    // MARK: - Color Picker

    private let shareColors: [Color] = [
        TapZeroDesign.Share.bgDark,
        TapZeroDesign.Share.bgLight,
        TapZeroDesign.Share.bgGreen,
        TapZeroDesign.Share.bgBlue,
        TapZeroDesign.Share.bgOrange,
        TapZeroDesign.Share.bgPurple
    ]

    private var colorPicker: some View {
        HStack(spacing: constants.colorPickerSpacing) {
            ForEach(Array(shareColors.enumerated()), id: \.offset) { _, color in
                colorDot(color: color)
            }
        }
    }

    private func colorDot(color: Color) -> some View {
        let isSelected = viewModel.selectedColor == color

        return Circle()
            .fill(color)
            .frame(
                width: constants.colorPickerSize,
                height: constants.colorPickerSize
            )
            .overlay(
                Circle()
                    .stroke(
                        TapZeroDesign.Foreground.primary,
                        lineWidth: isSelected ? 2.5 : 0
                    )
                    .padding(-3)
            )
            .overlay(
                Circle()
                    .stroke(
                        color == TapZeroDesign.Share.bgLight
                            ? TapZeroDesign.Hairline.medium
                            : Color.clear,
                        lineWidth: 1
                    )
            )
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.15)) {
                    viewModel.onColorSelected(color)
                }
            }
    }

    // MARK: - Share Button

    private var shareButton: some View {
        Button {
            let image = renderShareImage()
            viewModel.onShareTapped(image: image)
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 16, weight: .semibold))
                Text(TextKey.GameResult.share)
                    .font(TapZeroTypography.Label.button)
                    .tracking(-0.2)
            }
            .foregroundStyle(TapZeroDesign.Button.primaryForeground)
            .frame(maxWidth: .infinity)
            .frame(height: constants.shareButtonHeight)
            .background(TapZeroDesign.Button.primaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: constants.shareButtonRadius))
        }
    }

    // MARK: - Image Render

    private func renderShareImage() -> UIImage? {
        let view = cardContent
            .environment(\.colorScheme, .light)

        let renderer = ImageRenderer(content: view)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage
    }
}

// MARK: - Previews → SharePreviewScreen+Preview.swift
