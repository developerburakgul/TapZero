//
//  SplashScreen.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

struct SplashScreen: View {
    // MARK: - Private properties

    private let constants = Constants()

    // MARK: - Observed properties

    @StateObject var viewModel: SplashViewModel

    // MARK: - Animation States

    @State private var logoOpacity: Double = 0
    @State private var logoScale: CGFloat = 0.85
    @State private var titleOpacity: Double = 0
    @State private var taglineOpacity: Double = 0

    var body: some View {
        contentView
            .blur(radius: viewModel.isForceUpdatePresented ? 20 : 0)
            .brightness(viewModel.isForceUpdatePresented ? 0.35 : 0)
            .animation(.easeInOut(duration: 0.4), value: viewModel.isForceUpdatePresented)
            .task {
                if !viewModel.didAppearOnce {
                    viewModel.didAppearOnce = true
                    await viewModel.viewDidLoad()
                }
                await viewModel.viewWillAppear()
            }
    }

    private var contentView: some View {
        ZStack {
            TapZeroDesign.Background.primary
                .ignoresSafeArea()

            VStack(spacing: 0) {
                logoView
                    .padding(.bottom, 28)

                titleView

                taglineView
                    .padding(.top, 10)
            }
        }
        .onAppear(perform: startAnimations)
    }

    // MARK: - Logo (concentric rings + dot)

    private var logoView: some View {
        ZStack {
            // Outer ring
            Circle()
                .stroke(TapZeroDesign.Foreground.primary, lineWidth: 1.5)
                .frame(width: 86, height: 86)

            // Inner ring
            Circle()
                .stroke(TapZeroDesign.Foreground.primary.opacity(0.35), lineWidth: 1.5)
                .frame(width: 50, height: 50)

            // Dot at top
            Circle()
                .fill(TapZeroDesign.Foreground.primary)
                .frame(width: 8, height: 8)
                .offset(y: -43)
        }
        .opacity(logoOpacity)
        .scaleEffect(logoScale)
    }

    // MARK: - Title

    private var titleView: some View {
        Text(TextKey.Splash.brand)
            .font(TapZeroTypography.Display.brandLogo)
            .tracking(-1.6)
            .foregroundStyle(TapZeroDesign.Foreground.primary)
            .opacity(titleOpacity)
    }

    // MARK: - Tagline

    private var taglineView: some View {
        Text(TextKey.Splash.tagline)
            .font(TapZeroTypography.Body.cardLabel)
            .tracking(-0.1)
            .foregroundStyle(TapZeroDesign.Foreground.secondary)
            .opacity(taglineOpacity)
    }

    // MARK: - Animations

    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.7).delay(0.1)) {
            logoOpacity = 1.0
            logoScale = 1.0
        }
        withAnimation(.easeOut(duration: 0.5).delay(0.4)) {
            titleOpacity = 1.0
        }
        withAnimation(.easeOut(duration: 0.5).delay(0.6)) {
            taglineOpacity = 1.0
        }
    }
}

#Preview {
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    RouterView(id: "splash", addModuleSupport: true) { router in
        SplashBuilder.build(router: router)
    }
    .environment(\.locale, DevPreview.shared.locale)
}
