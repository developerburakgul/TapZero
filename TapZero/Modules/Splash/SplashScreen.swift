//
//  SplashScreen.swift
//  Created by __Username__ on __Date__
//

import Combine
import SwiftfulRouting
import SwiftUI

struct SplashScreen: View {
    // MARK: - Private properties
    private let constants = Constants()

    // MARK: - Observed properties
    @StateObject var viewModel: SplashViewModel

    // MARK: - Animation States
    @State private var animateGradient: Bool = false
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0
    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = 20
    @State private var shimmerOffset: CGFloat = -200
    @State private var dotIndex: Int = 0

    private let dotTimer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()

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
            LinearGradient(
                colors: [
                    TapZeroDesign.Splash.gradientStart,
                    TapZeroDesign.Splash.gradientMid,
                    TapZeroDesign.Splash.gradientEnd
                ],
                startPoint: animateGradient ? .topLeading : .bottomLeading,
                endPoint: animateGradient ? .bottomTrailing : .topTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()
                logoView
                titleView
                Spacer()
                loadingDotsView
            }
        }
        .onAppear(perform: startAnimations)
    }

    private var logoView: some View {
        Image(systemName: "app.fill")
            .font(.system(size: 72))
            .foregroundStyle(.white.opacity(0.9))
            .scaleEffect(logoScale)
            .opacity(logoOpacity)
    }

    private var titleView: some View {
        Text("TapZero")
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .opacity(titleOpacity)
            .offset(y: titleOffset)
            .overlay(
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white.opacity(0.3), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 80)
                    .offset(x: shimmerOffset)
                    .mask(
                        Text("TapZero")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                    )
            )
    }

    private var loadingDotsView: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(.white)
                    .frame(width: 8, height: 8)
                    .opacity(dotIndex == index ? 1.0 : 0.3)
                    .scaleEffect(dotIndex == index ? 1.3 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: dotIndex)
            }
        }
        .padding(.bottom, 48)
        .onReceive(dotTimer) { _ in
            dotIndex = (dotIndex + 1) % 3
        }
    }

    private func startAnimations() {
        withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
            animateGradient = true
        }
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        withAnimation(.easeOut(duration: 0.6).delay(0.5)) {
            titleOpacity = 1.0
            titleOffset = 0
        }
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false).delay(1.0)) {
            shimmerOffset = 200
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
