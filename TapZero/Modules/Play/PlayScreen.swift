//
//  PlayScreen.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

struct PlayScreen: View {
    // MARK: - Private properties
    private let constants = Constants()

    // MARK: - Observed properties
    @StateObject var viewModel: PlayViewModel

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

            Text(TextKey.Play.title)
                .foregroundStyle(TapZeroDesign.Foreground.primary)
        }
    }
}

#Preview {
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    RouterView(id: "play", addModuleSupport: true) { router in
        PlayBuilder.build(router: router)
    }
    .environment(\.locale, DevPreview.shared.locale)
}
