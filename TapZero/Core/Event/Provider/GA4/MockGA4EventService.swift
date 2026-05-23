//
//  MockGA4EventService.swift
//  TapZero
//

import Foundation

@MainActor
class MockGA4EventService: GA4EventServiceProtocol {
    private(set) var eventHistory: [(name: String, parameters: [String: Any])] = []
    private(set) var currentUserId: String?
    private(set) var userProperties: [String: String?] = [:]
    private(set) var defaultParameters: [String: Any] = [:]
    private(set) var collectionEnabled = true

    func sendEvent(name: String, parameters: [String: Any]) {
        eventHistory.append((name, parameters))
    }

    func setUserId(_ userId: String?) {
        currentUserId = userId
    }

    func setUserProperty(name: String, value: String?) {
        userProperties[name] = value
    }

    func setDefaultParameters(_ parameters: [String: Any]) {
        defaultParameters = parameters
    }

    func setAnalyticsCollectionEnabled(_ enabled: Bool) {
        collectionEnabled = enabled
    }

    func logScreenView(screenName: String, screenClass: String?) {
        sendEvent(name: "screen_view", parameters: ["screen_name": screenName])
    }
}
