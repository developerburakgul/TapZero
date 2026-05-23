//
//  LanguagePickerScreen.swift
//  TapZero
//

import SwiftUI

struct LanguagePickerScreen: View {
    @Binding var selectedLanguage: AppLanguage
    let onSelect: (AppLanguage) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                List {
                    ForEach(AppLanguage.allCases) { language in
                        languageRow(language)
                            .id(language)
                    }
                }
                .listStyle(.plain)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        proxy.scrollTo(selectedLanguage, anchor: .center)
                    }
                }
            }
            .navigationTitle(TextKey.Settings.language)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func languageRow(_ language: AppLanguage) -> some View {
        Button {
            onSelect(language)
            dismiss()
        } label: {
            HStack(spacing: 12) {
                Text(language.flagEmoji)
                    .font(.system(size: 28))

                VStack(alignment: .leading, spacing: 2) {
                    Text(language.nativeDisplayName)
                        .font(TapZeroTypography.Body.medium)
                        .foregroundStyle(TapZeroDesign.Foreground.primary)

                    Text(language.englishDisplayName)
                        .font(TapZeroTypography.Caption.regular)
                        .foregroundStyle(TapZeroDesign.Foreground.secondary)
                }

                Spacer()

                if language == selectedLanguage {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(TapZeroDesign.Accent.primary)
                } else {
                    Circle()
                        .strokeBorder(TapZeroDesign.Foreground.tertiary, lineWidth: 1.5)
                        .frame(width: 22, height: 22)
                }
            }
            .padding(.vertical, 4)
        }
    }
}
