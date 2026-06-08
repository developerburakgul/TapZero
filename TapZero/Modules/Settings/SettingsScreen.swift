//
//  SettingsScreen.swift
//  Created by __Username__ on __Date__
//

import DynamicColor
import StoreKit
import SwiftfulRouting
import SwiftUI

struct SettingsScreen: View {
    // MARK: - Private properties
    private let constants = Constants()

    // MARK: - Observed properties
    @StateObject var viewModel: SettingsViewModel
    @ObservedObject private var themeStore = ThemeStore.shared
    @Environment(\.requestReview) private var requestReview
    @Environment(\.openURL) private var openURL

    var body: some View {
        contentView
            .task {
                if !viewModel.didAppearOnce {
                    viewModel.didAppearOnce = true
                    await viewModel.viewDidLoad()
                }
                await viewModel.viewWillAppear()
            }
    }

    private var contentView: some View {
        List {
            profileHeaderSection
            appSettingsSection
            accountSection
            footerSection
        }
    }

    // MARK: - Profile Header

    private var profileHeaderSection: some View {
        Section {
            VStack(spacing: 8) {
                profileAvatar
                profileLabel
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }

    private var profileAvatar: some View {
        Group {
            if let urlString = viewModel.userManager.currentUser?.profileImageURL,
               let url = URL(string: urlString) {
                CachedAsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    initialAvatar
                }
            } else {
                initialAvatar
            }
        }
        .frame(width: constants.profileAvatarSize, height: constants.profileAvatarSize)
        .clipShape(Circle())
    }

    private var initialAvatar: some View {
        InitialAvatarView(
            initial: viewModel.userInitial,
            size: constants.profileAvatarSize,
            showDashedBorder: true
        )
    }

    @ViewBuilder
    private var profileLabel: some View {
        if !viewModel.displayName.isEmpty {
            Text(viewModel.displayName)
                .font(TapZeroTypography.Body.medium)
                .foregroundStyle(TapZeroDesign.Foreground.secondary)
        }
    }

    // MARK: - App Settings

    private var appSettingsSection: some View {
        Section {
            languageRow
            appearanceRow
            notificationRow
        } header: {
            Text(TextKey.Settings.appSettings)
        }
    }

    private var appearanceRow: some View {
        Button {
            viewModel.didTapAppearance()
        } label: {
            HStack {
                Label(TextKey.Settings.appearance, systemImage: "paintbrush.fill")
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
                Spacer()
                Text(themeDisplayName(for: themeStore.theme))
                    .font(TapZeroTypography.Body.medium)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)
            }
        }
    }

    private func themeDisplayName(for theme: AppTheme) -> LocalizedStringKey {
        switch theme {
        case .system: TextKey.Settings.Theme.system
        case .light: TextKey.Settings.Theme.light
        case .dark: TextKey.Settings.Theme.dark
        }
    }

    private var languageRow: some View {
        Button {
            viewModel.didTapLanguage()
        } label: {
            HStack {
                Label(TextKey.Settings.language, systemImage: "globe")
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
                Spacer()
                HStack(spacing: 4) {
                    Text(viewModel.selectedLanguage.flagEmoji)
                    Text(viewModel.selectedLanguage.nativeDisplayName)
                }
                    .font(TapZeroTypography.Body.medium)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)
            }
        }
    }

    private var notificationRow: some View {
        Button {
            viewModel.didTapNotification()
        } label: {
            HStack {
                Label(TextKey.Settings.notifications, systemImage: "bell.fill")
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
                Spacer()
                notificationStatusBadge
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(TapZeroDesign.Foreground.tertiary)
            }
        }
    }

    @ViewBuilder
    private var notificationStatusBadge: some View {
        if viewModel.notificationEnabled {
            HStack(spacing: 4) {
                Image(systemName: "checkmark.circle.fill")
                Text(TextKey.Settings.notificationEnabled)
                    .font(TapZeroTypography.Body.medium)
            }
            .foregroundStyle(TapZeroDesign.System.systemGreen)
        } else {
            Text(TextKey.Settings.notificationDisabled)
                .font(TapZeroTypography.Body.medium)
                .foregroundStyle(TapZeroDesign.Foreground.secondary)
        }
    }

    // MARK: - Account

    @ViewBuilder
    private var accountSection: some View {
        if viewModel.isAnonymous {
            Section {
                Button {
                    viewModel.didTapSignIn()
                } label: {
                    Label(TextKey.Settings.signUp, systemImage: "person.badge.plus")
                        .foregroundStyle(TapZeroDesign.Foreground.primary)
                }
                Button(role: .destructive) {
                    viewModel.didTapDeleteData()
                } label: {
                    Label(TextKey.Settings.deleteData, systemImage: "trash")
                }
            }
        } else {
            Section {
                providerRow
                Button {
                    viewModel.didTapSignOut()
                } label: {
                    Label(TextKey.Settings.signOut, systemImage: "rectangle.portrait.and.arrow.right")
                        .foregroundStyle(TapZeroDesign.Foreground.primary)
                }
                Button(role: .destructive) {
                    viewModel.didTapDeleteAccount()
                } label: {
                    Label(TextKey.Settings.deleteAccount, systemImage: "trash")
                }
            } header: {
                Text(TextKey.Settings.account)
            }
        }
    }

    private var providerRow: some View {
        HStack {
            Label {
                Text(providerDisplayName)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
            } icon: {
                providerIcon
            }
            Spacer()
            if let email = viewModel.userManager.currentUser?.email {
                Text(email)
                    .font(TapZeroTypography.Body.medium)
                    .foregroundStyle(TapZeroDesign.Foreground.secondary)
            }
        }
    }

    private var providerDisplayName: String {
        switch viewModel.authProvider {
        case .apple: "Apple"
        case .google: "Google"
        case .email: TextKey.Settings.providerEmailValue
        case .anonymous: ""
        }
    }

    @ViewBuilder
    private var providerIcon: some View {
        switch viewModel.authProvider {
        case .apple:
            Image(systemName: "apple.logo")
        case .google:
            Image("googleLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
        case .email:
            Image(systemName: "envelope.fill")
        case .anonymous:
            Image(systemName: "person.fill")
        }
    }

    // MARK: - Footer

    private var footerSection: some View {
        Section {
            VStack(spacing: 12) {
                appIconImage
                rateShareLinks
                aboutLinks
                versionLabel
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
    }
}

// MARK: - Footer Views

extension SettingsScreen {
    var rateShareLinks: some View {
        HStack(spacing: 4) {
            Button {
                requestReview()
            } label: {
                Text(TextKey.Settings.rateApp)
                    .underline()
            }
            Text("·")
                .foregroundStyle(TapZeroDesign.Foreground.tertiary)
            ShareLink(item: constants.appStoreURL) {
                Text(TextKey.Settings.shareApp)
                    .underline()
            }
        }
        .font(TapZeroTypography.Caption.regular)
        .foregroundStyle(TapZeroDesign.Foreground.secondary)
    }

    var aboutLinks: some View {
        HStack(spacing: 4) {
            Button {
                openURL(constants.privacyPolicyURL)
            } label: {
                Text(TextKey.Settings.privacyPolicy)
                    .underline()
                    .padding(.vertical, 4)
            }
            Text("·")
                .foregroundStyle(TapZeroDesign.Foreground.tertiary)
            Button {
                openURL(constants.termsOfServiceURL)
            } label: {
                Text(TextKey.Settings.termsOfService)
                    .underline()
                    .padding(.vertical, 4)
            }
        }
        .font(TapZeroTypography.Caption.regular)
        .foregroundStyle(TapZeroDesign.Foreground.secondary)
    }

    var appIconImage: some View {
        Image("AppIconDisplay")
            .resizable()
            .scaledToFit()
            .frame(width: 48, height: 48)
            .clipShape(RoundedRectangle(cornerRadius: 11))
    }

    var versionLabel: some View {
        HStack(spacing: 4) {
            Text(TextKey.Settings.version)
            Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-")
        }
        .font(TapZeroTypography.Caption.medium)
        .foregroundStyle(TapZeroDesign.Foreground.tertiary)
    }
}

#Preview {
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    RouterView(id: "settings", addModuleSupport: true) { router in
        SettingsBuilder.build(router: router)
    }
    .environment(\.locale, DevPreview.shared.locale)
}
