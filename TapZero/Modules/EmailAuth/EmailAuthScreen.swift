//
//  EmailAuthScreen.swift
//  TapZero
//

import DynamicColor
import SwiftfulRouting
import SwiftUI

struct EmailAuthScreen: View {
    @StateObject var viewModel: EmailAuthViewModel

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
        VStack(spacing: 24) {
            headerSection
            formSection
            submitButton
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "envelope.fill")
                .font(.system(size: 48))
                .foregroundStyle(TapZeroDesign.Foreground.primary)

            Text(viewModel.isSignUp ? TextKey.EmailAuth.signUpTitle : TextKey.EmailAuth.signInTitle)
                .font(TapZeroTypography.Display.medium)
                .foregroundStyle(TapZeroDesign.Foreground.primary)
        }
    }

    // MARK: - Form

    private var formSection: some View {
        VStack(spacing: 12) {
            TextField(TextKey.EmailAuth.emailPlaceholder, text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding()
                .background(TapZeroDesign.Background.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            SecureField(TextKey.EmailAuth.passwordPlaceholder, text: $viewModel.password)
                .textContentType(viewModel.isSignUp ? .newPassword : .password)
                .padding()
                .background(TapZeroDesign.Background.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Buttons

    private var submitButton: some View {
        Button {
            viewModel.didTapSubmit()
        } label: {
            Text(viewModel.isSignUp ? TextKey.EmailAuth.signUpButton : TextKey.EmailAuth.signInButton)
                .font(TapZeroTypography.Label.large)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(TapZeroDesign.Foreground.primary)
                .foregroundStyle(TapZeroDesign.Background.primary)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(viewModel.isLoading || viewModel.email.isEmpty || viewModel.password.isEmpty)
    }

    private var toggleModeButton: some View {
        Button {
            viewModel.didTapToggleMode()
        } label: {
            Text(viewModel.isSignUp ? TextKey.EmailAuth.switchToSignIn : TextKey.EmailAuth.switchToSignUp)
                .font(TapZeroTypography.Body.medium)
                .foregroundStyle(TapZeroDesign.Foreground.secondary)
        }
    }
}

#Preview {
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    RouterView(id: "emailAuth", addModuleSupport: true) { router in
        EmailAuthBuilder.build(router: router)
    }
    .environment(\.locale, DevPreview.shared.locale)
}
