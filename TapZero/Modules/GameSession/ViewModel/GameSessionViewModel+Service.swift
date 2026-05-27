//
//  GameSessionViewModel+Service.swift
//  TapZero
//

import Foundation

// MARK: - Service
extension GameSessionViewModel {
    func submitGame(
        targetSeconds: Int,
        tappedSeconds: Double,
        score: Int
    ) async {
        do {
            try await gameManager.submitGame(
                targetSeconds: targetSeconds,
                tappedSeconds: tappedSeconds,
                score: score
            )
        } catch {
            crashReporter.record(error: error)
        }
    }
}
