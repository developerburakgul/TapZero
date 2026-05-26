//
//  NumberPicker.swift
//  TapZero
//

import SwiftUI

extension PlayScreen {
    struct NumberPicker: View {
        @Binding var selectedTarget: Int
        let config: NumberPickerEntity.Config
        let constants: Constants

        @State private var scrolledID: Int?

        var body: some View {
            GeometryReader { outer in
                let containerWidth = outer.size.width
                let itemWidth = containerWidth * 0.38
                let sideMargin = (containerWidth - itemWidth) / 2

                VStack(spacing: 0) {
                    NumberPickerTickRail(
                        tickCount: constants.tickCount,
                        centerHeight: constants.centerTickHeight,
                        outerHeight: constants.outerTickHeight
                    )
                    .frame(height: 26)

                    scrollContent(
                        itemWidth: itemWidth,
                        sideMargin: sideMargin,
                        containerWidth: containerWidth
                    )
                }
            }
            .frame(height: constants.pickerHeight)
            .onAppear { scrolledID = selectedTarget }
            .onChange(of: scrolledID) { _, newID in
                guard let id = newID, id != selectedTarget else { return }
                selectedTarget = id
                HapticManager.selection()
            }
        }

        // MARK: - Scroll Content

        private func scrollContent(
            itemWidth: CGFloat,
            sideMargin: CGFloat,
            containerWidth: CGFloat
        ) -> some View {
            ZStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(config.minTarget...config.maxTarget, id: \.self) { number in
                            numberCell(
                                number: number,
                                itemWidth: itemWidth,
                                containerWidth: containerWidth
                            )
                            .frame(width: itemWidth)
                            .id(number)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $scrolledID)
                .contentMargins(.horizontal, sideMargin)
                .coordinateSpace(name: "picker")

                fadeOverlay
            }
        }

        // MARK: - Number Cell

        private func numberCell(
            number: Int,
            itemWidth: CGFloat,
            containerWidth: CGFloat
        ) -> some View {
            GeometryReader { geo in
                let midX = geo.frame(in: .named("picker")).midX
                let centerX = containerWidth / 2
                let distance = min(abs(midX - centerX) / itemWidth, 3.0)
                let style = styleFor(distance: distance)

                Text("\(number)")
                    .font(.system(size: style.size, weight: style.weight).monospacedDigit())
                    .tracking(-5)
                    .lineLimit(1)
                    .fixedSize()
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
                    .opacity(style.opacity)
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
            }
        }

        // MARK: - Style Interpolation

        private struct NumberStyle {
            let size: CGFloat
            let opacity: Double
            let weight: Font.Weight
        }

        private func styleFor(distance: CGFloat) -> NumberStyle {
            let sizes: [CGFloat] = [132, 72, 48, 36]
            let opacities: [Double] = [1.0, 0.3, 0.15, 0.08]

            let lower = Int(distance)
            let upper = min(lower + 1, 3)
            let fraction = distance - CGFloat(lower)

            let size = sizes[lower] + (sizes[upper] - sizes[lower]) * fraction
            let opacity = opacities[lower] + (opacities[upper] - opacities[lower]) * Double(fraction)

            let weight: Font.Weight
            switch Int(round(distance)) {
            case 0: weight = .bold
            case 1: weight = .medium
            default: weight = .regular
            }

            return NumberStyle(size: size, opacity: opacity, weight: weight)
        }

        // MARK: - Fade

        private var fadeOverlay: some View {
            HStack(spacing: 0) {
                LinearGradient(
                    colors: [TapZeroDesign.Background.primary, .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: constants.sideFadeWidth)

                Spacer()

                LinearGradient(
                    colors: [.clear, TapZeroDesign.Background.primary],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: constants.sideFadeWidth)
            }
            .allowsHitTesting(false)
        }
    }
}
