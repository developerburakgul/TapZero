//
//  AppearancePickerScreen.swift
//  TapZero
//

import DynamicColor
import SwiftUI

struct AppearancePickerScreen: View {
    @ObservedObject var themeStore: ThemeStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                themePicker
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .navigationTitle(TextKey.Settings.appearance)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var themePicker: some View {
        HStack(spacing: 12) {
            themeCard(
                theme: .system,
                icon: "circle.lefthalf.filled",
                label: TextKey.Settings.Theme.system
            )
            themeCard(
                theme: .light,
                icon: "sun.max.fill",
                label: TextKey.Settings.Theme.light
            )
            themeCard(
                theme: .dark,
                icon: "moon.fill",
                label: TextKey.Settings.Theme.dark
            )
        }
    }

    private func themeCard(
        theme: AppTheme,
        icon: String,
        label: LocalizedStringKey
    ) -> some View {
        let isSelected = themeStore.theme == theme

        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                themeStore.theme = theme
            }
        } label: {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .frame(width: 56, height: 56)
                    .foregroundStyle(
                        isSelected
                        ? TapZeroDesign.Background.primary
                        : TapZeroDesign.Foreground.primary
                    )
                    .background(
                        isSelected
                        ? TapZeroDesign.Foreground.primary
                        : TapZeroDesign.Background.secondary
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                Text(label)
                    .font(TapZeroTypography.Caption.medium)
                    .foregroundStyle(
                        isSelected
                        ? TapZeroDesign.Foreground.primary
                        : TapZeroDesign.Foreground.secondary
                    )
            }
            .frame(maxWidth: .infinity)
        }
    }
}
