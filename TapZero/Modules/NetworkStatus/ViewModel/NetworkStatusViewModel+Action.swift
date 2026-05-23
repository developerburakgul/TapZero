//
//  NetworkStatusViewModel+Action.swift
//  TapZero
//

import Foundation

// MARK: - Actions
extension NetworkStatusViewModel {
    /// Called from .task modifier — first appear only (viewDidLoad)
    func viewDidLoad() async {
        sendEvent(type: .pageAppear)
    }

    /// Called from .task modifier — every appear (viewWillAppear)
    func viewWillAppear() async {
        configure()
    }
}
