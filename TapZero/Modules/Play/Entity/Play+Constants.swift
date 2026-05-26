//
//  Play+Constants.swift
//  TapZero
//

import SwiftUI

extension PlayScreen {
    struct Constants {
        // Target range
        let minTarget: Int = 1
        let maxTarget: Int = 30
        let defaultTarget: Int = 10

        // Layout
        let horizontalPadding: CGFloat = 24
        let avatarSize: CGFloat = 34

        // NumberPicker
        let pickerHeight: CGFloat = 220
        let tickCount: Int = 21
        let centerTickHeight: CGFloat = 12
        let outerTickHeight: CGFloat = 6
        let sideFadeWidth: CGFloat = 80
        let numberGap: CGFloat = 26
        let numberTracking: CGFloat = -5
        let numberSizes: [CGFloat] = [36, 48, 72, 132, 72, 48, 36]
        let numberWidths: [CGFloat] = [48, 70, 110, 172, 110, 70, 48]
        let numberOpacities: [Double] = [0.08, 0.15, 0.3, 1.0, 0.3, 0.15, 0.08]
        let numberWeights: [Font.Weight] = [.regular, .regular, .medium, .bold, .medium, .regular, .regular]

        // Play Button
        let playButtonHeight: CGFloat = 60
        let playButtonCornerRadius: CGFloat = 18
    }
}
