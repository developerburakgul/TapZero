//
//  FirebaseCrashReporter.swift
//  TapZero
//

import FirebaseCrashlytics
import Foundation

@MainActor
struct FirebaseCrashReporter: CrashReporterProtocol {
    private let crashlytics = Crashlytics.crashlytics()

    func setUserId(_ userId: String?) {
        crashlytics.setUserID(userId ?? "")
    }

    func log(_ message: String) {
        crashlytics.log(message)
    }

    func record(error: Error) {
        crashlytics.record(error: error)
    }
}
