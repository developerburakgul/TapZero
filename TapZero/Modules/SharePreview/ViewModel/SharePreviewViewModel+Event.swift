//
//  SharePreviewViewModel+Event.swift
//  TapZero
//

// MARK: - Events
extension SharePreviewViewModel {
    enum EventType {
        case pageAppear
        case shareTapped
    }

    func sendEvent(type: EventType) {
        switch type {
        case .pageAppear:
            eventManager.ga4.sendEvent(name: "share_preview_viewed", parameters: [:])
        case .shareTapped:
            eventManager.ga4.sendEvent(name: "share_preview_shared", parameters: [:])
        }
    }
}
