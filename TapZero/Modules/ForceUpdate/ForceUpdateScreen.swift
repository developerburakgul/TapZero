//
//  ForceUpdateScreen.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

struct ForceUpdateScreen: View {
    // MARK: - Observed properties
    @StateObject var viewModel: ForceUpdateViewModel

    // MARK: - Animation States
    @State private var showIcon: Bool = false
    @State private var showText: Bool = false
    @State private var showVersion: Bool = false
    @State private var showButton: Bool = false
    @State private var bounceIcon: Bool = false

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
        ZStack {
            LinearGradient(
                colors: [
                    TapZeroDesign.ForceUpdate.sheetGradientStart,
                    TapZeroDesign.ForceUpdate.sheetGradientEnd
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()
                iconSection
                textSection
                versionSection
                Spacer()
                updateButton
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 36)
            .padding(.top, 24)
        }
        .onAppear { runAnimations() }
    }

    // MARK: - Icon

    private var iconSection: some View {
        ZStack {
            Circle()
                .fill(TapZeroDesign.ForceUpdate.iconBackground.opacity(0.4))
                .frame(width: 120, height: 120)

            Circle()
                .fill(TapZeroDesign.ForceUpdate.iconBackground)
                .frame(width: 88, height: 88)

            Image(systemName: "arrow.down.app.fill")
                .font(.system(size: 40))
                .foregroundStyle(TapZeroDesign.ForceUpdate.icon)
                .offset(y: bounceIcon ? -5 : 5)
        }
        .opacity(showIcon ? 1 : 0)
        .scaleEffect(showIcon ? 1.0 : 0.5)
    }

    // MARK: - Text

    private var textSection: some View {
        VStack(spacing: 10) {
            Text(TextKey.ForceUpdate.title)
                .font(TapZeroTypography.Display.medium)
                .foregroundStyle(TapZeroDesign.Foreground.primary)

            Text(TextKey.ForceUpdate.message)
                .font(TapZeroTypography.Body.medium)
                .foregroundStyle(TapZeroDesign.Foreground.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .opacity(showText ? 1 : 0)
        .offset(y: showText ? 0 : 12)
    }

    // MARK: - Version

    private var versionSection: some View {
        HStack(spacing: 16) {
            Text("v\(viewModel.entity.currentVersion)")
                .font(TapZeroTypography.Label.large)
                .foregroundStyle(TapZeroDesign.ForceUpdate.currentVersion)

            FlowingDots()

            Text("v\(viewModel.entity.requiredVersion)")
                .font(TapZeroTypography.Label.large)
                .foregroundStyle(TapZeroDesign.ForceUpdate.requiredVersion)
        }
        .opacity(showVersion ? 1 : 0)
        .offset(y: showVersion ? 0 : 12)
    }

    // MARK: - Button

    private var updateButton: some View {
        Button {
            viewModel.didTapUpdate()
        } label: {
            HStack(spacing: 8) {
                Text(TextKey.ForceUpdate.button)
                    .font(TapZeroTypography.Label.large)
                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(TapZeroDesign.Foreground.primary)
            .foregroundStyle(TapZeroDesign.Background.primary)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .opacity(showButton ? 1 : 0)
        .offset(y: showButton ? 0 : 16)
    }

    // MARK: - Animation

    private func runAnimations() {
        withAnimation(.spring(duration: 0.6, bounce: 0.4).delay(0.1)) {
            showIcon = true
        }
        withAnimation(.easeOut(duration: 0.4).delay(0.35)) {
            showText = true
        }
        withAnimation(.easeOut(duration: 0.4).delay(0.55)) {
            showVersion = true
        }
        withAnimation(.easeOut(duration: 0.4).delay(0.75)) {
            showButton = true
        }
        withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true).delay(0.8)) {
            bounceIcon = true
        }
    }
}

// MARK: - Flowing Dots

private struct FlowingDots: View {
    @State private var activeIndex: Int = 0

    private let timer = Timer.publish(every: 0.35, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(TapZeroDesign.Foreground.tertiary)
                    .frame(width: 4, height: 4)
                    .opacity(activeIndex == index ? 1.0 : 0.25)
                    .animation(.easeInOut(duration: 0.3), value: activeIndex)
            }
        }
        .fixedSize()
        .onReceive(timer) { _ in
            activeIndex = (activeIndex + 1) % 3
        }
    }
}

#Preview("Force Update") { // swiftlint:disable:this closure_body_length
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    // Splash arka plani (blur'lu)
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
    .blur(radius: 12)
    .sheet(isPresented: .constant(true)) {
        RouterView(id: "forceUpdate") { router in
            ForceUpdateBuilder.build(
                router: router,
                entity: ForceUpdateEntity(currentVersion: "26.5.0", requiredVersion: "26.5.1")
            )
        }
        .presentationDetents([.fraction(0.65)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(24)
        .presentationBackground(
            LinearGradient(
                colors: [
                    TapZeroDesign.ForceUpdate.sheetGradientStart,
                    TapZeroDesign.ForceUpdate.sheetGradientEnd
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .interactiveDismissDisabled(true)
    }
    .environment(\.locale, DevPreview.shared.locale)
}
