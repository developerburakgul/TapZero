//
//  NumberPickerNumbers.swift
//  TapZero
//

import SwiftUI

extension PlayScreen {
    struct NumberPickerNumbers: View {
        let selectedTarget: Int
        let minTarget: Int
        let maxTarget: Int
        let sizes: [CGFloat]
        let widths: [CGFloat]
        let opacities: [Double]
        let weights: [Font.Weight]
        let visibleRange: Int

        var body: some View {
            HStack(alignment: .center, spacing: 26) {
                ForEach(-visibleRange...visibleRange, id: \.self) { offset in
                    let number = selectedTarget + offset
                    let valid = number >= minTarget && number <= maxTarget
                    let styleIndex = styleIndexFor(offset: offset)
                    Text(valid ? "\(number)" : "")
                        .font(.system(
                            size: sizes[styleIndex],
                            weight: weights[styleIndex]
                        ).monospacedDigit())
                        .tracking(-5)
                        .lineLimit(1)
                        .frame(minWidth: widths[styleIndex])
                        .foregroundStyle(TapZeroDesign.Foreground.primary)
                        .opacity(valid ? opacities[styleIndex] : 0)
                }
            }
        }

        private func styleIndexFor(offset: Int) -> Int {
            let absOffset = min(abs(offset), 3)
            // Map: 0→3(center), 1→2or4, 2→1or5, 3→0or6
            return 3 + (offset >= 0 ? absOffset : -absOffset)
        }
    }
}
