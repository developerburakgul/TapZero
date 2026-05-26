//
//  TabbarScreen.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

struct TabbarScreen: View {
    // MARK: - Private properties
    private let constants = Constants()

    // MARK: - Observed properties
    @StateObject var viewModel: TabbarViewModel

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
        TabView(selection: $viewModel.selectedTab) {
            RouterView(id: "play", addModuleSupport: true) { router in
                viewModel.buildPlayScreen(router: router)
            }
            .tabItem {
                Label(TextKey.Tabbar.play, systemImage: "play.fill")
            }
            .tag(TabbarTab.play)

            RouterView(id: "leaderboard", addModuleSupport: true) { router in
                viewModel.buildLeaderBoardScreen(router: router)
            }
            .tabItem {
                Label(TextKey.Tabbar.leaderBoard, systemImage: "trophy.fill")
            }
            .tag(TabbarTab.leaderBoard)

            RouterView(id: "history", addModuleSupport: true) { router in
                viewModel.buildHistoryScreen(router: router)
            }
            .tabItem {
                Label(TextKey.Tabbar.history, systemImage: "clock.fill")
            }
            .tag(TabbarTab.history)

            RouterView(id: "settings", addModuleSupport: true) { router in
                viewModel.buildSettingsScreen(router: router)
            }
            .tabItem {
                Label(TextKey.Tabbar.settings, systemImage: "gearshape.fill")
            }
            .tag(TabbarTab.settings)
        }
        .onChange(of: viewModel.selectedTab) { newTab in
            viewModel.onTabChanged(newTab)
        }
    }
}

#Preview {
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    RouterView(id: "tabbar", addModuleSupport: true) { router in
        TabbarBuilder.build(router: router)
    }
    .environment(\.locale, DevPreview.shared.locale)
}
