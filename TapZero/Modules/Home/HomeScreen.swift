//
//  HomeScreen.swift
//  Created by __Username__ on __Date__
//

import SwiftfulRouting
import SwiftUI

struct HomeScreen: View {
    // MARK: - Private properties
    private let constants = Constants()

    // MARK: - Observed properties
    @StateObject var viewModel: HomeViewModel

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
            TapZeroDesign.Background.primary.ignoresSafeArea()

            Text(TextKey.Home.title)
                .foregroundStyle(TapZeroDesign.Foreground.primary)
        }
    }
}

#Preview {
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    RouterView(id: "home", addModuleSupport: true) { router in
        HomeBuilder.build(router: router)
    }
    .environment(\.locale, DevPreview.shared.locale)
}
