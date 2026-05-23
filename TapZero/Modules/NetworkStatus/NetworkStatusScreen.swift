//
//  NetworkStatusScreen.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

struct NetworkStatusScreen: View {
    // MARK: - Observed properties
    @StateObject var viewModel: NetworkStatusViewModel

    // MARK: - Animation States
    @State private var showIcon: Bool = false
    @State private var showText: Bool = false
    @State private var pulseIcon: Bool = false

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
        ZStack {
            LinearGradient(
                colors: [
                    TapZeroDesign.NetworkStatus.sheetGradientStart,
                    TapZeroDesign.NetworkStatus.sheetGradientEnd
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()
                iconSection
                textSection
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }

    // MARK: - Icon

    private var iconSection: some View {
        ZStack {
            Circle()
                .fill(TapZeroDesign.NetworkStatus.iconBackground.opacity(0.4))
                .frame(width: 120, height: 120)

            Circle()
                .fill(TapZeroDesign.NetworkStatus.iconBackground)
                .frame(width: 88, height: 88)

            Image(systemName: "wifi.slash")
                .font(.system(size: 40))
                .foregroundStyle(TapZeroDesign.NetworkStatus.icon)
                .scaleEffect(pulseIcon ? 1.1 : 1.0)
        }
        .opacity(showIcon ? 1 : 0)
        .scaleEffect(showIcon ? 1.0 : 0.5)
    }

    // MARK: - Text

    private var textSection: some View {
        VStack(spacing: 10) {
            Text(TextKey.NetworkStatus.title)
                .font(TapZeroTypography.Display.medium)
                .foregroundStyle(TapZeroDesign.Foreground.primary)

            Text(TextKey.NetworkStatus.message)
                .font(TapZeroTypography.Body.medium)
                .foregroundStyle(TapZeroDesign.Foreground.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .opacity(showText ? 1 : 0)
        .offset(y: showText ? 0 : 12)
    }

    // MARK: - Animation

    private func runAnimations() {
        withAnimation(.spring(duration: 0.6, bounce: 0.4).delay(0.1)) {
            showIcon = true
        }
        withAnimation(.easeOut(duration: 0.4).delay(0.35)) {
            showText = true
        }
        withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true).delay(0.8)) {
            pulseIcon = true
        }
    }
}

#Preview("Network Status") { // swiftlint:disable:this closure_body_length
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    ZStack {
        LinearGradient(
            colors: [
                TapZeroDesign.Splash.gradientStart,
                TapZeroDesign.Splash.gradientMid,
                TapZeroDesign.Splash.gradientEnd
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        VStack(spacing: 20) {
            Image(systemName: "app.fill")
                .font(.system(size: 72))
                .foregroundStyle(.white.opacity(0.9))
            Text("TapZero")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
        }
    }
    .blur(radius: 20)
    .brightness(0.35)
    .sheet(isPresented: .constant(true)) {
        RouterView(id: "networkStatus", addModuleSupport: true) { router in
            NetworkStatusBuilder.build(router: router)
        }
        .presentationDetents([.fraction(0.55)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(24)
        .presentationBackground(
            LinearGradient(
                colors: [
                    TapZeroDesign.NetworkStatus.sheetGradientStart,
                    TapZeroDesign.NetworkStatus.sheetGradientEnd
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .interactiveDismissDisabled(true)
    }
    .environment(\.locale, DevPreview.shared.locale)
}
