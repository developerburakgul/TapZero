//
//  ImageCacheManager.swift
//  TapZero
//

import UIKit

actor ImageCacheManager {
    static let shared = ImageCacheManager()

    private let memoryCache = NSCache<NSString, UIImage>()
    private let diskCacheURL: URL
    private let config: ImageCacheConfig
    private let fileManager = FileManager.default

    init(config: ImageCacheConfig = .default) {
        self.config = config
        self.memoryCache.countLimit = config.memoryCountLimit

        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.diskCacheURL = caches.appendingPathComponent(config.diskDirectoryName)

        if config.usesDisk, !FileManager.default.fileExists(atPath: diskCacheURL.path) {
            try? FileManager.default.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
        }
    }

    // MARK: - Public

    func image(for url: URL) async -> UIImage? {
        let key = cacheKey(for: url)

        if config.usesMemory, let cached = memoryCache.object(forKey: key as NSString) {
            return cached
        }

        if config.usesDisk, let diskImage = loadFromDisk(key: key) {
            if config.usesMemory {
                memoryCache.setObject(diskImage, forKey: key as NSString)
            }
            return diskImage
        }

        return await downloadAndCache(url: url, key: key)
    }

    func setImage(_ image: UIImage, for url: URL) {
        let key = cacheKey(for: url)
        if config.usesMemory {
            memoryCache.setObject(image, forKey: key as NSString)
        }
        if config.usesDisk {
            saveToDisk(image: image, key: key)
        }
    }

    func removeImage(for url: URL) {
        let key = cacheKey(for: url)
        if config.usesMemory {
            memoryCache.removeObject(forKey: key as NSString)
        }
        if config.usesDisk {
            removeFromDisk(key: key)
        }
    }

    func clearAll() {
        if config.usesMemory {
            memoryCache.removeAllObjects()
        }
        if config.usesDisk {
            try? fileManager.removeItem(at: diskCacheURL)
            try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
        }
    }

    // MARK: - Private

    private func cacheKey(for url: URL) -> String {
        url.absoluteString.data(using: .utf8)
            .map { data in
                data.map { String(format: "%02x", $0) }.joined()
            } ?? url.absoluteString
    }

    private func diskPath(for key: String) -> URL {
        diskCacheURL.appendingPathComponent(key)
    }

    private func loadFromDisk(key: String) -> UIImage? {
        let path = diskPath(for: key)
        guard fileManager.fileExists(atPath: path.path) else { return nil }

        guard let attributes = try? fileManager.attributesOfItem(atPath: path.path),
              let modDate = attributes[.modificationDate] as? Date,
              Date().timeIntervalSince(modDate) < config.ttl else {
            removeFromDisk(key: key)
            return nil
        }

        guard let data = try? Data(contentsOf: path) else { return nil }
        return UIImage(data: data)
    }

    private func saveToDisk(image: UIImage, key: String) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let path = diskPath(for: key)
        try? data.write(to: path)
    }

    private func removeFromDisk(key: String) {
        let path = diskPath(for: key)
        try? fileManager.removeItem(at: path)
    }

    private func downloadAndCache(url: URL, key: String) async -> UIImage? {
        guard let (data, _) = try? await URLSession.shared.data(from: url),
              let image = UIImage(data: data) else {
            return nil
        }
        if config.usesMemory {
            memoryCache.setObject(image, forKey: key as NSString)
        }
        if config.usesDisk {
            saveToDisk(image: image, key: key)
        }
        return image
    }
}
