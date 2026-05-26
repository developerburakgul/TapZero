//
//  HistoryScreen.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

struct HistoryScreen: View {
    // MARK: - Private properties
    private let constants = Constants()

    // MARK: - Observed properties
    @StateObject var viewModel: HistoryViewModel

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

            Text(TextKey.History.title)
                .foregroundStyle(TapZeroDesign.Foreground.primary)
        }
    }
}

#Preview {
    let _ = DevPreview.shared // swiftlint:disable:this redundant_discardable_let

    RouterView(id: "history", addModuleSupport: true) { router in
        HistoryBuilder.build(router: router)
    }
    .environment(\.locale, DevPreview.shared.locale)
}
