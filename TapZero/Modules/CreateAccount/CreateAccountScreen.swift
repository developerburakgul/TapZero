//
//  CreateAccountScreen.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

struct CreateAccountScreen: View {
    // MARK: - Private properties
    private let constants = Constants()

    // MARK: - Observed properties
    @StateObject var viewModel: CreateAccountViewModel

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
        VStack(spacing: 12) {
            headerView
                .padding(.bottom, 4)

            appleButton
            googleButton
            emailButton

            if viewModel.entity.showGuestOption {
                guestButton
                    .padding(.top, 4)
            }
        }
        .padding(.horizontal, constants.horizontalPadding)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    // MARK: - Header

    private var headerTitle: LocalizedStringKey {
        viewModel.entity.isSignIn ? TextKey.CreateAccount.signInTitle : TextKey.CreateAccount.title
    }

    private var headerSubtitle: LocalizedStringKey {
        viewModel.entity.isSignIn ? TextKey.CreateAccount.signInSubtitle : TextKey.CreateAccount.subtitle
    }

    private var headerView: some View {
        VStack(spacing: 6) {
            Text(headerTitle)
                .font(TapZeroTypography.Heading.h2)
                .foregroundStyle(TapZeroDesign.Foreground.primary)

            Text(headerSubtitle)
                .font(TapZeroTypography.Body.medium)
                .foregroundStyle(TapZeroDesign.Foreground.secondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Buttons

    private var appleButton: some View {
        Button(action: viewModel.didTapApple) {
            HStack(spacing: 12) {
                Image(systemName: "apple.logo")
                    .font(.title3)
                    .frame(width: constants.iconFrameWidth)
                Text(TextKey.CreateAccount.apple)
                    .font(TapZeroTypography.Label.large)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: constants.buttonHeight)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: constants.buttonCornerRadius))
        }
        .disabled(viewModel.isLoading)
    }

    private var googleButton: some View {
        Button(action: viewModel.didTapGoogle) {
            HStack(spacing: 12) {
                Image("googleLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .frame(width: constants.iconFrameWidth)
                Text(TextKey.CreateAccount.google)
                    .font(TapZeroTypography.Label.large)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: constants.buttonHeight)
            .background(TapZeroDesign.Background.secondary)
            .clipShape(RoundedRectangle(cornerRadius: constants.buttonCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: constants.buttonCornerRadius)
                    .strokeBorder(TapZeroDesign.Foreground.tertiary.opacity(0.3))
            )
        }
        .disabled(viewModel.isLoading)
    }

    private var emailButton: some View {
        Button(action: viewModel.didTapEmail) {
            HStack(spacing: 12) {
                Image(systemName: "envelope.fill")
                    .font(.title3)
                    .foregroundStyle(TapZeroDesign.Accent.primary)
                    .frame(width: constants.iconFrameWidth)
                Text(TextKey.CreateAccount.email)
                    .font(TapZeroTypography.Label.large)
                    .foregroundStyle(TapZeroDesign.Foreground.primary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: constants.buttonHeight)
            .background(TapZeroDesign.Background.secondary)
            .clipShape(RoundedRectangle(cornerRadius: constants.buttonCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: constants.buttonCornerRadius)
                    .strokeBorder(TapZeroDesign.Foreground.tertiary.opacity(0.3))
            )
        }
        .disabled(viewModel.isLoading)
    }

    private var guestButton: some View {
        Button(action: viewModel.didTapGuest) {
            Text(TextKey.CreateAccount.guest)
                .font(TapZeroTypography.Body.medium)
                .foregroundStyle(TapZeroDesign.Foreground.secondary)
                .underline()
        }
        .disabled(viewModel.isLoading)
    }
}

#Preview {
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    RouterView(id: "createAccount", addModuleSupport: true) { router in
        CreateAccountBuilder.build(router: router)
    }
    .environment(\.locale, DevPreview.shared.locale)
}
