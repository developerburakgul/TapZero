//
//  FileManagerUserPersistence.swift
//  TapZero
//

import Foundation

struct FileManagerUserPersistence: LocalUserPersistenceProtocol {

    private let fileName = "current_user.json"

    private var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent(fileName)
    }

    func getCurrentUser() -> UserModel? {
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return try? JSONDecoder().decode(UserModel.self, from: data)
    }

    func saveCurrentUser(user: UserModel?) throws {
        if let user {
            let data = try JSONEncoder().encode(user)
            try data.write(to: fileURL)
        } else {
            try? FileManager.default.removeItem(at: fileURL)
        }
    }
}
