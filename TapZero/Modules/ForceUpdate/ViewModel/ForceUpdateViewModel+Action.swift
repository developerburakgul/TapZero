//
//  ForceUpdateViewModel+Action.swift
//  TapZero
//

import Foundation
import SwiftUI

// MARK: - Actions
extension ForceUpdateViewModel {
    /// Called from .task modifier — first appear only (viewDidLoad)
    func viewDidLoad() async {
        sendEvent(type: .pageAppear)
    }

    /// Called from .task modifier — every appear (viewWillAppear)
    func viewWillAppear() async {
        configure()
    }

    // MARK: - Update

    func didTapUpdate() {
        sendEvent(type: .tappedUpdate)
        let constants = ForceUpdateScreen.Constants()
        UIApplication.shared.open(constants.appStoreURL)
    }
}
