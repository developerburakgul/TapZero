//
//  NWPathNetworkMonitor.swift
//  TapZero
//

import Foundation
import Network

@MainActor
final class NWPathNetworkMonitor: NetworkMonitorServiceProtocol {
    private(set) var isConnected: Bool = true
    var onStatusChange: (@MainActor (Bool) -> Void)?

    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "com.networkmonitor.queue", qos: .utility)

    init(requiredInterfaceType: NWInterface.InterfaceType? = nil) {
        if let type = requiredInterfaceType {
            self.monitor = NWPathMonitor(requiredInterfaceType: type)
        } else {
            self.monitor = NWPathMonitor()
        }
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                guard let self else { return }
                let connected = path.status == .satisfied
                guard self.isConnected != connected else { return }
                self.isConnected = connected
                self.onStatusChange?(connected)
            }
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }

    deinit {
        monitor.cancel()
    }
}
