//
//  FirebaseGA4EventService.swift
//  TapZero
//

import FirebaseAnalytics
import Foundation

@MainActor
struct FirebaseGA4EventService: GA4EventServiceProtocol {
    func sendEvent(name: String, parameters: [String: Any]) {
        let sanitizedName = GA4EventSanitizer.sanitizeEventName(name)
        let sanitizedParams = GA4EventSanitizer.sanitizeParameters(parameters)
        Analytics.logEvent(sanitizedName, parameters: sanitizedParams)
    }

    func setUserId(_ userId: String?) {
        Analytics.setUserID(userId)
    }

    func setUserProperty(name: String, value: String?) {
        Analytics.setUserProperty(value, forName: name)
    }

    func setDefaultParameters(_ parameters: [String: Any]) {
        Analytics.setDefaultEventParameters(parameters)
    }

    func setAnalyticsCollectionEnabled(_ enabled: Bool) {
        Analytics.setAnalyticsCollectionEnabled(enabled)
    }

    func logScreenView(screenName: String, screenClass: String?) {
        var params: [String: Any] = [AnalyticsParameterScreenName: screenName]
        if let screenClass {
            params[AnalyticsParameterScreenClass] = screenClass
        }
        Analytics.logEvent(AnalyticsEventScreenView, parameters: params)
    }
}
