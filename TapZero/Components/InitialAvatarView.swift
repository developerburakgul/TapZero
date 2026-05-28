//
//  InitialAvatarView.swift
//  TapZero
//

import SwiftUI

struct InitialAvatarView: View {
    let initial: String
    let size: CGFloat
    let showDashedBorder: Bool

    init(initial: String, size: CGFloat, showDashedBorder: Bool = false) {
        self.initial = initial
        self.size = size
        self.showDashedBorder = showDashedBorder
    }

    var body: some View {
        Circle()
            .fill(TapZeroDesign.Background.secondary)
            .overlay {
                if showDashedBorder {
                    Circle()
                        .strokeBorder(
                            style: StrokeStyle(lineWidth: 1, dash: [6, 4])
                        )
                        .foregroundStyle(TapZeroDesign.Foreground.tertiary)
                }
            }
            .overlay {
                Text(initial)
                    .font(.system(size: size * 0.38, weight: .medium))
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
            }
            .frame(width: size, height: size)
    }
}

// MARK: - Previews

#Preview("Small — No Border") {
    InitialAvatarView(initial: "BG", size: 38)
        .background(TapZeroDesign.Background.primary)
}

#Preview("Medium — Dashed Border") {
    InitialAvatarView(initial: "B", size: 84, showDashedBorder: true)
        .background(TapZeroDesign.Background.primary)
}

#Preview("Large — Dashed Border") {
    InitialAvatarView(initial: "B", size: 180, showDashedBorder: true)
        .background(TapZeroDesign.Background.primary)
}
