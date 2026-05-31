//
//  HistoryViewModel+Event.swift
//  TapZero
//

// MARK: - Events
extension HistoryViewModel {
    enum EventType {
        case pageAppear
        case tabSwitched(tab: HistoryTab)
        case filterChanged(target: Int?)
        case sortChanged(order: HistoryScreen.FilterSortEntity.SortOrder)
    }

    func sendEvent(type: EventType) {
        switch type {
        case .pageAppear:
            eventManager.ga4.sendEvent(name: "history_viewed", parameters: [:])
        case .tabSwitched(let tab):
            eventManager.ga4.sendEvent(
                name: "history_switched_tab",
                parameters: ["tab": tab == .scores ? "scores" : "stats"]
            )
        case .filterChanged(let target):
            eventManager.ga4.sendEvent(
                name: "history_changed_filter",
                parameters: ["target": target.map { String($0) } ?? "all"]
            )
        case .sortChanged(let order):
            eventManager.ga4.sendEvent(
                name: "history_changed_sort",
                parameters: ["order": order.rawValue]
            )
        }
    }
}
