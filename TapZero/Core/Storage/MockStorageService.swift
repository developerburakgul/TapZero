//
//  MockStorageService.swift
//  TapZero
//

import Foundation

@MainActor
class MockStorageService: StorageServiceProtocol {
    private var urls: [String: URL] = [:]

    func uploadImage(data: Data, path: String) async throws -> URL {
        guard let url = URL(string: AppConstants.mockStorageBaseURL + path) else {
            throw StorageError.fileNotFound
        }
        urls[path] = url
        return url
    }

    func downloadURL(path: String) async throws -> URL {
        guard let url = urls[path] else {
            throw StorageError.fileNotFound
        }
        return url
    }

    func deleteImage(path: String) async throws {
        urls.removeValue(forKey: path)
    }

    enum StorageError: LocalizedError {
        case fileNotFound

        var errorDescription: String? {
            switch self {
            case .fileNotFound:
                "File not found in mock storage."
            }
        }
    }
}
