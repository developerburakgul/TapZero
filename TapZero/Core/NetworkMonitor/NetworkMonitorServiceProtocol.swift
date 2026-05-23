//
//  NetworkMonitorServiceProtocol.swift
//  TapZero
//

import Foundation

@MainActor
protocol NetworkMonitorServiceProtocol: AnyObject {
    var isConnected: Bool { get }
    var onStatusChange: (@MainActor (Bool) -> Void)? { get set }
    func startMonitoring()
    func stopMonitoring()
}
