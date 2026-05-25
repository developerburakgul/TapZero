//
//  IntroFooter.swift
//  TapZero
//

import SwiftUI

struct IntroFooter: View {
    let index: Int
    let totalPages: Int
    let ctaLabel: LocalizedStringKey
    let action: () -> Void

    init(
        index: Int,
        totalPages: Int = 3,
        ctaLabel: LocalizedStringKey,
        action: @escaping () -> Void
    ) {
        self.index = index
        self.totalPages = totalPages
        self.ctaLabel = ctaLabel
        self.action = action
    }

    var body: some View {
        VStack(spacing: 18) {
            pageDots
            primaryButton
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 18)
    }

    private var pageDots: some View {
        HStack(spacing: 6) {
            ForEach(0..<totalPages, id: \.self) { i in
                Capsule()
                    .fill(
                        i == index
                            ? TapZeroDesign.Foreground.primary
                            : TapZeroDesign.Foreground.primary.opacity(0.18)
                    )
                    .frame(width: i == index ? 22 : 6, height: 6)
                    .animation(.easeInOut(duration: 0.2), value: index)
            }
        }
    }

    private var primaryButton: some View {
        Button(action: action) {
            Text(ctaLabel)
                .font(TapZeroTypography.Label.button)
                .tracking(-0.2)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(TapZeroDesign.Button.primaryBackground)
                .foregroundStyle(TapZeroDesign.Button.primaryForeground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
