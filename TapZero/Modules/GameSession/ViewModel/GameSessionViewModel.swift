//
//  GameSessionViewModel.swift
//  TapZero
//

import Combine
import SwiftfulRouting
import SwiftUI

@MainActor
final class GameSessionViewModel: ObservableObject {
    // MARK: - Non-Published Properties
    var didAppearOnce: Bool = false
    let router: Router
    let entity: GameSessionEntity
    var startTime: Date?
    var countdownTask: Task<Void, Never>?
    var hasRecordedTap: Bool = false

    // MARK: - Managers
    @Injected private(set) var eventManager: EventManager
    @Injected private(set) var gameManager: GameManager
    @Injected private(set) var crashReporter: CrashReporterProtocol

    // MARK: - Published Properties
    @Published var phase: GamePhase = .countdown
    @Published var countdownValue: Int = 3
    @Published var showGo: Bool = false
    @Published var tapPosition: CGPoint?
    @Published var showRipple: Bool = false

    // MARK: - Init
    init(
        router: Router,
        entity: GameSessionEntity
    ) {
        self.router = router
        self.entity = entity
    }

    deinit {
        countdownTask?.cancel()
    }
}

// MARK: - Phase
extension GameSessionViewModel {
    enum GamePhase: Equatable {
        case countdown
        case gameplay
    }
}

// MARK: - Computed Properties
extension GameSessionViewModel {
    var targetTimeFormatted: String {
        String(format: "%d.00", entity.targetSeconds)
    }
}
