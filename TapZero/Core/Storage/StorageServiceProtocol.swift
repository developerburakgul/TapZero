//
//  StorageServiceProtocol.swift
//  TapZero
//

import Foundation

@MainActor
protocol StorageServiceProtocol: Sendable {
    func uploadImage(data: Data, path: String) async throws -> URL
    func downloadURL(path: String) async throws -> URL
    func deleteImage(path: String) async throws
}
