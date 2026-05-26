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
        var offset: CGFloat = 0

        var body: some View {
            HStack(spacing: 8) {
                ForEach(0..<tickCount, id: \.self) { index in
                    let center = tickCount / 2
                    let distance = abs(index - center)
                    let isMajor = distance == 0

                    Capsule()
                        .fill(TapZeroDesign.Foreground.primary)
                        .frame(
                            width: isMajor ? 1.5 : 1,
                            height: isMajor ? centerHeight : tickHeight(distance: distance)
                        )
                        .opacity(isMajor ? 1 : tickOpacity(distance: distance))
                }
            }
            .offset(x: offset)
        }

        private func tickHeight(distance: Int) -> CGFloat {
            if distance < 3 { return 8 }
            return outerHeight
        }

        private func tickOpacity(distance: Int) -> Double {
            max(0.06, 0.4 - Double(distance) * 0.04)
        }
    }
}
