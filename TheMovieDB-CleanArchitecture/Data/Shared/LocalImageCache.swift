//
//  LocalImageCache.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 24/06/22.
//

import Foundation

final public class LocalImageCache: ImageCache {
    public typealias Result = ImageCache.Result
    typealias CacheType = NSCache<NSString, NSData>

    public enum Error: Swift.Error, LocalizedError {
        case noImageWithThatKey
        public var errorDescription: String? {
            switch self {
            case .noImageWithThatKey:
                return NSLocalizedString("There was no image with that URL", comment: "CacheError")
            }
        }
    }

    lazy var imageDataCache: CacheType = {
        let cache = CacheType()
        cache.countLimit = 75
        return cache
    }()

    public func load(url: URL, completion: @escaping (Result) -> Void) {
        let key = url.absoluteString as NSString
        guard let data = imageDataCache.object(forKey: key) else {
            return completion(.failure(Error.noImageWithThatKey))
        }
        return completion(.success(data as Data))
    }

    public func save(_ data: Data, for url: URL) {
        let key = url.absoluteString as NSString
        imageDataCache.setObject(data as NSData, forKey: key)
    }
}
