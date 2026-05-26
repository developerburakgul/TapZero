//
//  HistoryViewModel+Action.swift
//  TapZero
//

import Foundation

// MARK: - Actions
extension HistoryViewModel {
    /// Called from .task modifier — first appear only (viewDidLoad)
    func viewDidLoad() async {
        await sendInitialRequests()
    }

    /// Called from .task modifier — every appear (viewWillAppear)
    func viewWillAppear() async {
        configure()
        sendEvent(type: .pageAppear)
    }

    func sendInitialRequests() async {
        await withTaskGroup { group in
            group.addTask {
                await self.fetchData()
            }
        }
    }
}
