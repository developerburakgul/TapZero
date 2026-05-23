//
//  FavoritesScreen.swift
//  Created by __Username__ on __Date__
//

import SwiftfulRouting
import SwiftUI

struct FavoritesScreen: View {
    // MARK: - Private properties
    private let constants = Constants()

    // MARK: - Observed properties
    @StateObject var viewModel: FavoritesViewModel

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

            Text(TextKey.Favorites.title)
                .foregroundStyle(TapZeroDesign.Foreground.primary)
        }
    }
}

#Preview {
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    RouterView(id: "favorites", addModuleSupport: true) { router in
        FavoritesBuilder.build(router: router)
    }
    .environment(\.locale, DevPreview.shared.locale)
}
