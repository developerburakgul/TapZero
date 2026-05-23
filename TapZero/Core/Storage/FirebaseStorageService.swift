//
//  FirebaseStorageService.swift
//  TapZero
//

import FirebaseStorage
import Foundation

@MainActor
struct FirebaseStorageService: StorageServiceProtocol {
    private let storage = Storage.storage()

    func uploadImage(data: Data, path: String) async throws -> URL {
        let ref = storage.reference().child(path)
        let metadata = StorageMetadata()
        metadata.contentType = AppConstants.imageContentType
        _ = try await ref.putDataAsync(data, metadata: metadata)
        return try await ref.downloadURL()
    }

    func downloadURL(path: String) async throws -> URL {
        try await storage.reference().child(path).downloadURL()
    }

    func deleteImage(path: String) async throws {
        try await storage.reference().child(path).delete()
    }
}
