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
        .background(TapZeroDesign.Background.primary)
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
            .padding(constants.cardPadding)
            .background(viewModel.selectedColor)
            .clipShape(RoundedRectangle(cornerRadius: 22))
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
                targetSeconds: viewModel.entity.targetSeconds
            ),
            constants: GameResultScreen.Constants()
        )
    }

    // MARK: - Color Picker

    private var colorPicker: some View {
        HStack(spacing: constants.colorPickerSpacing) {
            ForEach(
                Array(viewModel.backgroundColors.enumerated()),
                id: \.offset
            ) { _, color in
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
                        color == Color(hex: TapZeroPalette.Neutral.N0)
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
            .padding(constants.cardPadding)
            .background(viewModel.selectedColor)
            .clipShape(RoundedRectangle(cornerRadius: 22))

        let renderer = ImageRenderer(content: view)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage
    }
}

#Preview("Good Score") {
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    RouterView(id: "sharePreview", addModuleSupport: true) { router in
        SharePreviewBuilder.build(
            router: router,
            entity: SharePreviewEntity(
                score: 847,
                targetSeconds: 5,
                tappedSeconds: 5.08,
                delta: 0.08,
                performanceRating: .good
            )
        )
    }
    .environment(\.locale, DevPreview.shared.locale)
}

#Preview("Perfect Score") {
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    RouterView(id: "sharePreview2", addModuleSupport: true) { router in
        SharePreviewBuilder.build(
            router: router,
            entity: SharePreviewEntity(
                score: 1000,
                targetSeconds: 10,
                tappedSeconds: 10.00,
                delta: 0.0,
                performanceRating: .perfect
            )
        )
    }
    .environment(\.locale, DevPreview.shared.locale)
}

#Preview("Bad Score") {
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    RouterView(id: "sharePreview3", addModuleSupport: true) { router in
        SharePreviewBuilder.build(
            router: router,
            entity: SharePreviewEntity(
                score: 320,
                targetSeconds: 5,
                tappedSeconds: 6.12,
                delta: 1.12,
                performanceRating: .bad
            )
        )
    }
    .environment(\.locale, DevPreview.shared.locale)
}

#Preview("Mid Score") {
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    RouterView(id: "sharePreview4", addModuleSupport: true) { router in
        SharePreviewBuilder.build(
            router: router,
            entity: SharePreviewEntity(
                score: 640,
                targetSeconds: 5,
                tappedSeconds: 4.50,
                delta: 0.50,
                performanceRating: .mid
            )
        )
    }
    .environment(\.locale, DevPreview.shared.locale)
}
