//
//  FirebaseGameService.swift
//  TapZero
//

import FirebaseFirestore
import FirebaseFunctions

@MainActor
struct FirebaseGameService: GameServiceProtocol {
    // MARK: - Collection References

    private var functions: Functions {
        Functions.functions()
    }

    private func gamesCollection(userId: String) -> CollectionReference {
        Firestore.firestore().collection("users/\(userId)/games")
    }

    private func userStatsDocument(userId: String) -> DocumentReference {
        Firestore.firestore().document("userStats/\(userId)")
    }

    private var globalLeaderboardCollection: CollectionReference {
        Firestore.firestore().collection("leaderboard/global/entries")
    }

    private func dailyLeaderboardCollection(dateString: String) -> CollectionReference {
        Firestore.firestore().collection("leaderboard/daily_\(dateString)/entries")
    }

    // MARK: - Cloud Functions

    func submitGame(targetSeconds: Int, tappedSeconds: Double, score: Int) async throws -> SubmitGameResponse {
        let data: [String: Any] = [
            "targetSeconds": targetSeconds,
            "tappedSeconds": tappedSeconds,
            "score": score
        ]

        let result = try await functions.httpsCallable("submitGame").call(data)

        guard let responseData = result.data as? [String: Any] else {
            throw SubmitGameError.invalidResponse
        }

        return try SubmitGameResponse(data: responseData)
    }

    func deleteAccount() async throws {
        _ = try await functions.httpsCallable("deleteAccount").call()
    }

    // MARK: - Firestore Reads

    func fetchGameHistory(userId: String, limit: Int) async throws -> [GameModel] {
        let snapshot = try await gamesCollection(userId: userId)
            .order(by: "playedAt", descending: true)
            .limit(to: limit)
            .getDocuments()

        return snapshot.documents.compactMap { doc in
            try? doc.data(as: GameModel.self)
        }
    }

    func fetchUserStats(userId: String) async throws -> UserStatsModel? {
        let document = try await userStatsDocument(userId: userId).getDocument()

        guard document.exists else { return nil }

        return try document.data(as: UserStatsModel.self)
    }

    func fetchGlobalLeaderboard(limit: Int) async throws -> [GlobalLeaderboardEntry] {
        let snapshot = try await globalLeaderboardCollection
            .order(by: "top10Average", descending: true)
            .limit(to: limit)
            .getDocuments()

        return snapshot.documents.compactMap { doc in
            try? doc.data(as: GlobalLeaderboardEntry.self)
        }
    }

    func fetchDailyLeaderboard(dateString: String, limit: Int) async throws -> [DailyLeaderboardEntry] {
        let snapshot = try await dailyLeaderboardCollection(dateString: dateString)
            .order(by: "bestScore", descending: true)
            .limit(to: limit)
            .getDocuments()

        return snapshot.documents.compactMap { doc in
            try? doc.data(as: DailyLeaderboardEntry.self)
        }
    }
}
