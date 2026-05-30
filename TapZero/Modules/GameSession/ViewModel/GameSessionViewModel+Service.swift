//
//  GameSessionViewModel+Service.swift
//  TapZero
//

import FirebaseAuth
import Foundation

// MARK: - Service
extension GameSessionViewModel {
    func submitGame(
        targetSeconds: Int,
        tappedSeconds: Double,
        score: Int
    ) async {
        // swiftlint:disable:next no_print
        print("[GameSession] Auth UID: \(Auth.auth().currentUser?.uid ?? "nil")")
        // swiftlint:disable:next no_print
        print("[GameSession] Is anonymous: \(Auth.auth().currentUser?.isAnonymous ?? true)")
        // swiftlint:disable:next no_print
        print("[GameSession] Providers: \(Auth.auth().currentUser?.providerData.map(\.providerID) ?? [])")

        do {
            _ = try await gameManager.submitGame(
                targetSeconds: targetSeconds,
                tappedSeconds: tappedSeconds,
                score: score
            )
        } catch {
            // swiftlint:disable:next no_print
            print("[GameSession] submitGame error: \(error)")
            crashReporter.record(error: error)
        }
    }
}
