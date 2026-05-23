//
//  MockCrashReporter.swift
//  TapZero
//

import Foundation

@MainActor
struct MockCrashReporter: CrashReporterProtocol {
    func setUserId(_ userId: String?) {}
    func log(_ message: String) {}
    func record(error: Error) {}
}
