//
//  MockNetworkMonitor.swift
//  TapZero
//

import Foundation

@MainActor
final class MockNetworkMonitor: NetworkMonitorServiceProtocol {
    private(set) var isConnected: Bool
    var onStatusChange: (@MainActor (Bool) -> Void)?

    init(isConnected: Bool = true) {
        self.isConnected = isConnected
    }

    func startMonitoring() {}
    func stopMonitoring() {}

    func setConnected(_ connected: Bool) {
        guard isConnected != connected else { return }
        isConnected = connected
        onStatusChange?(connected)
    }
}
