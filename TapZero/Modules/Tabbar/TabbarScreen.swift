//
//  TabbarScreen.swift
//  Created by __Username__ on __Date__
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
            RouterView(id: "home", addModuleSupport: true) { router in
                viewModel.buildHomeScreen(router: router)
            }
            .tabItem {
                Label(TextKey.Tabbar.home, systemImage: "house.fill")
            }
            .tag(TabbarTab.home)

            RouterView(id: "favorites", addModuleSupport: true) { router in
                viewModel.buildFavoritesScreen(router: router)
            }
            .tabItem {
                Label(TextKey.Tabbar.favorites, systemImage: "heart.fill")
            }
            .tag(TabbarTab.favorites)

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
