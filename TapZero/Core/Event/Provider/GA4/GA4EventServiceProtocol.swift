//
//  GA4EventServiceProtocol.swift
//  TapZero
//

import Foundation

@MainActor
protocol GA4EventServiceProtocol: Sendable {
    func sendEvent(name: String, parameters: [String: Any])
    func setUserId(_ userId: String?)
    func setUserProperty(name: String, value: String?)
    func setDefaultParameters(_ parameters: [String: Any])
    func setAnalyticsCollectionEnabled(_ enabled: Bool)
    func logScreenView(screenName: String, screenClass: String?)
}
