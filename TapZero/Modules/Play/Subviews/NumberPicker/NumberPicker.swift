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

                ZStack(alignment: .top) {
                    scrollView(
                        itemWidth: itemWidth,
                        sideMargin: sideMargin,
                        containerWidth: containerWidth
                    )
                    fadeOverlay
                }
            }
            .frame(height: constants.pickerHeight)
            .onAppear { scrolledID = selectedTarget }
            .onChange(of: scrolledID) { _, newID in
                guard let id = newID, id != selectedTarget else { return }
                selectedTarget = id
                HapticManager.pickerTick()
            }
        }

        // MARK: - Scroll View

        private func scrollView(
            itemWidth: CGFloat,
            sideMargin: CGFloat,
            containerWidth: CGFloat
        ) -> some View {
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
                let cellOffset = midX - centerX
                let distance = min(abs(cellOffset) / itemWidth, 3.0)
                let style = styleFor(distance: distance)

                VStack(spacing: 0) {
                    cellTickRail(
                        cellOffset: cellOffset,
                        cellWidth: geo.size.width,
                        centerX: centerX
                    )
                    .padding(.top, 14)

                    Spacer()

                    Text(TextKey.number(number))
                        .font(.system(size: style.size, weight: style.weight).monospacedDigit())
                        .tracking(-5)
                        .lineLimit(1)
                        .fixedSize()
                        .foregroundStyle(TapZeroDesign.Foreground.primary)
                        .opacity(style.opacity)

                    Spacer()
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }

        // MARK: - Cell Tick Rail

        private func cellTickRail(
            cellOffset: CGFloat,
            cellWidth: CGFloat,
            centerX: CGFloat
        ) -> some View {
            let step: CGFloat = 9
            let count = max(1, Int(cellWidth / step)) | 1 // force odd
            let halfCount = count / 2

            return HStack(spacing: step - 1) {
                ForEach(0..<count, id: \.self) { i in
                    let tickLocalX = CGFloat(i - halfCount) * step
                    let tickScreenDist = abs(cellOffset + tickLocalX)
                    let normalizedDist = tickScreenDist / 80

                    Capsule()
                        .fill(TapZeroDesign.Foreground.primary)
                        .frame(
                            width: normalizedDist < 0.04 ? 1.5 : 1,
                            height: tickHeightFor(normalizedDist: normalizedDist)
                        )
                        .opacity(tickOpacityFor(normalizedDist: normalizedDist))
                }
            }
            .frame(height: 12)
        }

        private func tickHeightFor(normalizedDist: CGFloat) -> CGFloat {
            if normalizedDist < 0.04 { return 12 }
            if normalizedDist < 0.18 { return 8 + (1 - normalizedDist / 0.18) * 2 }
            if normalizedDist < 0.38 { return 6 + (1 - normalizedDist / 0.38) * 2 }
            return 5
        }

        private func tickOpacityFor(normalizedDist: CGFloat) -> Double {
            if normalizedDist < 0.04 { return 1.0 }
            if normalizedDist < 0.38 { return 0.5 - normalizedDist * 0.5 }
            return max(0.06, 0.25 - normalizedDist * 0.08)
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
