//
//  GameSessionViewModel+Action.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

// MARK: - Actions
extension GameSessionViewModel {
    func viewDidLoad() async {
        startCountdown()
    }

    func viewWillAppear() async {
        configure()
        sendEvent(type: .pageAppear)
    }

    // MARK: - Countdown

    func startCountdown() {
        hasRecordedTap = false
        showRipple = false
        tapPosition = nil
        countdownValue = 3
        showGo = false
        phase = .countdown

        countdownTask = Task {
            for value in [3, 2, 1] {
                withAnimation(.easeInOut(duration: 0.3)) {
                    countdownValue = value
                }
                HapticManager.impact(.medium)
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled else { return }
            }

            withAnimation(.easeInOut(duration: 0.2)) {
                showGo = true
            }
            HapticManager.notification(.success)
            try? await Task.sleep(for: .milliseconds(400))
            guard !Task.isCancelled else { return }

            startTime = Date()
            withAnimation(.easeInOut(duration: 0.3)) {
                showGo = false
                phase = .gameplay
            }
        }
    }

    // MARK: - Gameplay Tap

    func onScreenTapped(at position: CGPoint) {
        guard phase == .gameplay, !hasRecordedTap, let startTime else { return }
        hasRecordedTap = true

        let tappedSeconds = Date().timeIntervalSince(startTime)
        HapticManager.impact(.heavy)

        tapPosition = position
        withAnimation(.easeOut(duration: 0.5)) {
            showRipple = true
        }

        let score = ScoreCalculator.calculate(
            targetSeconds: entity.targetSeconds,
            tappedSeconds: tappedSeconds
        )
        let delta = abs(tappedSeconds - Double(entity.targetSeconds))
        let rating = PerformanceRating(delta: delta)

        sendEvent(type: .tapped(target: entity.targetSeconds, tapped: tappedSeconds, score: score))

        Task {
            await submitGame(
                targetSeconds: entity.targetSeconds,
                tappedSeconds: tappedSeconds,
                score: score
            )
        }

        Task {
            try? await Task.sleep(for: .milliseconds(500))
            guard !Task.isCancelled else { return }
            presentResult(
                tappedSeconds: tappedSeconds,
                score: score,
                delta: delta,
                rating: rating
            )
        }
    }

    // MARK: - Present Result

    private func presentResult(
        tappedSeconds: Double,
        score: Int,
        delta: Double,
        rating: PerformanceRating
    ) {
        let resultEntity = GameResultEntity(
            score: score,
            targetSeconds: entity.targetSeconds,
            tappedSeconds: tappedSeconds,
            delta: delta,
            performanceRating: rating
        )

        let config = ResizableSheetConfig(
            detents: [.fraction(0.75)],
            dragIndicator: .hidden
        )

        router.showScreen(.sheetConfig(config: config)) { [weak self] router in
            GameResultBuilder.build(
                router: router,
                entity: resultEntity
            ) {
                self?.onPlayAgain()
            }
            .interactiveDismissDisabled(true)
        }
    }

    // MARK: - Play Again

    func onPlayAgain() {
        sendEvent(type: .playAgain)
        startCountdown()
    }

    // MARK: - Close

    func onClose() {
        countdownTask?.cancel()
        sendEvent(type: .closed)
        router.dismissScreen()
    }
}
