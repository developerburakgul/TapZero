//
//  NetworkMonitorManager.swift
//  TapZero
//

import Foundation

@MainActor
final class NetworkMonitorManager: ObservableObject {
    @Published private(set) var isConnected: Bool = true

    private let service: NetworkMonitorServiceProtocol

    init(service: NetworkMonitorServiceProtocol) {
        self.service = service
        self.isConnected = service.isConnected
        self.service.onStatusChange = { [weak self] connected in
            self?.isConnected = connected
        }
    }

    func startMonitoring() {
        service.startMonitoring()
    }

    func stopMonitoring() {
        service.stopMonitoring()
    }
}
