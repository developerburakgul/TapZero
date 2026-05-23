//
//  CrashReporterProtocol.swift
//  TapZero
//

import Foundation

@MainActor
protocol CrashReporterProtocol: Sendable {
    func setUserId(_ userId: String?)
    func log(_ message: String)
    func record(error: Error)
}
