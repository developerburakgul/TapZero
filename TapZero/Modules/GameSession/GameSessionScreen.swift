//
//  GameSessionScreen.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

struct GameSessionScreen: View {
    // MARK: - Private properties
    private let constants = Constants()

    // MARK: - Observed properties
    @StateObject var viewModel: GameSessionViewModel

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
            switch viewModel.phase {
            case .countdown:
                CountdownView(
                    config: .init(
                        countdownValue: viewModel.countdownValue,
                        showGo: viewModel.showGo
                    ),
                    constants: constants
                )
                .transition(.opacity)

            case .gameplay:
                GameplayView(
                    config: .init(
                        targetTimeFormatted: viewModel.targetTimeFormatted,
                        tapPosition: viewModel.tapPosition,
                        showRipple: viewModel.showRipple
                    ),
                    constants: constants
                )
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { value in
                            viewModel.onScreenTapped(at: value.location)
                        }
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.phase)
    }
}

#Preview {
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    RouterView(id: "gameSession", addModuleSupport: true) { router in
        GameSessionBuilder.build(
            router: router,
            entity: GameSessionEntity(targetSeconds: 5)
        )
    }
    .environment(\.locale, DevPreview.shared.locale)
}
