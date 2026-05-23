//
//  ImageCacheConfig.swift
//  TapZero
//

import Foundation

struct ImageCacheConfig {
    enum CachePolicy {
        case memoryOnly
        case diskOnly
        case memoryAndDisk
    }

    let policy: CachePolicy
    let memoryCountLimit: Int
    let diskSizeLimit: Int
    let diskDirectoryName: String
    let ttl: TimeInterval

    static let `default` = Self(
        policy: .memoryOnly,
        memoryCountLimit: 100,
        diskSizeLimit: 200 * 1024 * 1024, // 200 MB
        diskDirectoryName: "ImageCache",
        ttl: 7 * 24 * 60 * 60 // 7 days
    )

    var usesMemory: Bool {
        policy == .memoryOnly || policy == .memoryAndDisk
    }

    var usesDisk: Bool {
        policy == .diskOnly || policy == .memoryAndDisk
    }
}
