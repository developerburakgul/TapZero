//
//  EventManager.swift
//  TapZero
//

import Foundation

@MainActor
final class EventManager {
    let ga4: GA4EventServiceProtocol

    init(ga4: GA4EventServiceProtocol) {
        self.ga4 = ga4
    }
}
