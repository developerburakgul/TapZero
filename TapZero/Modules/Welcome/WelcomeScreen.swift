//
//  WelcomeScreen.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

struct WelcomeScreen: View {
    @StateObject var viewModel: WelcomeViewModel

    @State private var showLogo: Bool = false
    @State private var showTitle: Bool = false
    @State private var showSubtitle: Bool = false
    @State private var showButtons: Bool = false

    var body: some View {
        contentView
            .task {
                if !viewModel.didAppearOnce {
                    viewModel.didAppearOnce = true
                    await viewModel.viewDidLoad()
                }
                await viewModel.viewWillAppear()
            }
            .onAppear { runAnimations() }
    }

    private var contentView: some View {
        VStack(spacing: 0) {
            Spacer()
            logoSection
            textSection
            Spacer()
            buttonsSection
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 48)
        .background(TapZeroDesign.Background.primary.ignoresSafeArea())
    }

    // MARK: - Logo

    private var logoSection: some View {
        ZStack {
            Circle()
                .fill(TapZeroDesign.Accent.primary.opacity(0.08))
                .frame(width: 140, height: 140)
                .scaleEffect(showLogo ? 1.0 : 0.5)
                .opacity(showLogo ? 1 : 0)

            Circle()
                .fill(TapZeroDesign.Accent.primary.opacity(0.15))
                .frame(width: 100, height: 100)
                .scaleEffect(showLogo ? 1.0 : 0.6)
                .opacity(showLogo ? 1 : 0)

            Image(systemName: "app.fill")
                .font(.system(size: 48))
                .foregroundStyle(TapZeroDesign.Accent.primary)
                .scaleEffect(showLogo ? 1.0 : 0.01)
        }
    }

    // MARK: - Text

    private var textSection: some View {
        VStack(spacing: 8) {
            Text(TextKey.Welcome.title)
                .font(TapZeroTypography.Display.large)
                .foregroundStyle(TapZeroDesign.Foreground.primary)
                .opacity(showTitle ? 1 : 0)
                .offset(y: showTitle ? 0 : 15)

            Text(TextKey.Welcome.subtitle)
                .font(TapZeroTypography.Body.medium)
                .foregroundStyle(TapZeroDesign.Foreground.secondary)
                .multilineTextAlignment(.center)
                .opacity(showSubtitle ? 1 : 0)
                .offset(y: showSubtitle ? 0 : 10)
        }
        .padding(.top, 28)
    }

    // MARK: - Buttons

    private var buttonsSection: some View {
        VStack(spacing: 12) {
            signInButton
            startButton
        }
        .opacity(showButtons ? 1 : 0)
        .offset(y: showButtons ? 0 : 20)
    }

    private var signInButton: some View {
        Button {
            viewModel.didTapSignIn()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "person.fill")
                    .font(.system(size: 16, weight: .medium))
                Text(TextKey.Welcome.signIn)
                    .font(TapZeroTypography.Label.large)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(TapZeroDesign.Foreground.primary)
            .foregroundStyle(TapZeroDesign.Background.primary)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(viewModel.isLoading)
    }

    private var startButton: some View {
        Button {
            viewModel.didTapStart()
        } label: {
            HStack(spacing: 8) {
                Text(TextKey.Welcome.start)
                    .font(TapZeroTypography.Label.large)
                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .foregroundStyle(TapZeroDesign.Foreground.primary)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(TapZeroDesign.Foreground.tertiary, lineWidth: 1.5)
            )
        }
        .disabled(viewModel.isLoading)
    }

    // MARK: - Animation

    private func runAnimations() {
        showLogo = false
        showTitle = false
        showSubtitle = false
        showButtons = false

        withAnimation(.spring(duration: 0.6, bounce: 0.4).delay(0.1)) {
            showLogo = true
        }
        withAnimation(.easeOut(duration: 0.4).delay(0.4)) {
            showTitle = true
        }
        withAnimation(.easeOut(duration: 0.4).delay(0.6)) {
            showSubtitle = true
        }
        withAnimation(.easeOut(duration: 0.4).delay(0.8)) {
            showButtons = true
        }
    }
}

#Preview {
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    RouterView(id: "welcome", addModuleSupport: true) { router in
        WelcomeBuilder.build(router: router)
    }
    .environment(\.locale, DevPreview.shared.locale)
}
