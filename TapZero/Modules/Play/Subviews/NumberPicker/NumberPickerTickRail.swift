//
//  NumberPickerTickRail.swift
//  TapZero
//

import SwiftUI

extension PlayScreen {
    struct NumberPickerTickRail: View {
        let tickCount: Int
        let centerHeight: CGFloat
        let outerHeight: CGFloat

        var body: some View {
            HStack(spacing: 8) {
                ForEach(0..<tickCount, id: \.self) { index in
                    let center = tickCount / 2
                    let distance = abs(index - center)
                    let isCenterTick = distance == 0

                    Capsule()
                        .fill(TapZeroDesign.Foreground.primary)
                        .frame(
                            width: isCenterTick ? 1.5 : 1,
                            height: isCenterTick ? centerHeight : tickHeight(distance: distance)
                        )
                        .opacity(tickOpacity(distance: distance))
                }
            }
        }

        private func tickHeight(distance: Int) -> CGFloat {
            let progress = CGFloat(distance) / CGFloat(tickCount / 2)
            return outerHeight + (centerHeight - outerHeight) * (1 - progress) * 0.5
        }

        private func tickOpacity(distance: Int) -> Double {
            let progress = Double(distance) / Double(tickCount / 2)
            return max(0.15, 1.0 - progress * 0.85)
        }
    }
}
