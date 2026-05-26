//
//  TabbarScreen.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

private struct TabBarMinimizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26, *) {
            content.tabBarMinimizeBehavior(.onScrollDown)
        } else {
            content
        }
    }
}

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
            playTab
            leaderBoardTab
            historyTab
            settingsTab
        }
        .tint(TapZeroDesign.Foreground.primary)
        .modifier(TabBarMinimizeModifier())
        .onChange(of: viewModel.selectedTab) { newTab in
            viewModel.onTabChanged(newTab)
        }
    }

    // MARK: - Tabs

    private var playTab: some View {
        RouterView(id: "play", addModuleSupport: true) { router in
            viewModel.buildPlayScreen(router: router)
        }
        .tabItem {
            Label(
                TextKey.Tabbar.play,
                systemImage: viewModel.selectedTab == .play
                    ? "play.fill" : "play"
            )
            .environment(\.symbolVariants, .none)
        }
        .tag(TabbarTab.play)
    }

    private var leaderBoardTab: some View {
        RouterView(id: "leaderboard", addModuleSupport: true) { router in
            viewModel.buildLeaderBoardScreen(router: router)
        }
        .tabItem {
            Label(
                TextKey.Tabbar.leaderBoard,
                systemImage: viewModel.selectedTab == .leaderBoard
                    ? "trophy.fill" : "trophy"
            )
            .environment(\.symbolVariants, .none)
        }
        .tag(TabbarTab.leaderBoard)
    }

    private var historyTab: some View {
        RouterView(id: "history", addModuleSupport: true) { router in
            viewModel.buildHistoryScreen(router: router)
        }
        .tabItem {
            Label(
                TextKey.Tabbar.history,
                systemImage: viewModel.selectedTab == .history
                    ? "clock.fill" : "clock"
            )
            .environment(\.symbolVariants, .none)
        }
        .tag(TabbarTab.history)
    }

    private var settingsTab: some View {
        RouterView(id: "settings", addModuleSupport: true) { router in
            viewModel.buildSettingsScreen(router: router)
        }
        .tabItem {
            Label(
                TextKey.Tabbar.settings,
                systemImage: viewModel.selectedTab == .settings
                    ? "gearshape.fill" : "gearshape"
            )
            .environment(\.symbolVariants, .none)
        }
        .tag(TabbarTab.settings)
    }
}

#Preview {
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    RouterView(id: "tabbar", addModuleSupport: true) { router in
        TabbarBuilder.build(router: router)
    }
    .environment(\.locale, DevPreview.shared.locale)
}
