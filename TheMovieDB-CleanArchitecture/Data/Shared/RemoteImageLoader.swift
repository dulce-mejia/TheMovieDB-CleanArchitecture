//
//  RemoteImageLoader.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 24/06/22.
//

import Foundation

public final class RemoteImageLoader: ImageLoader {
    public typealias Result = ImageLoader.Result

    let client: HTTPClient
    let cache: ImageCache

    public init(client: HTTPClient, cache: ImageCache) {
        self.client = client
        self.cache = cache
    }

    public func load(url: URL, completion: @escaping (Result) -> Void) {
        cache.load(url: url) { [weak self] result in
            switch result {
            case let .success(imageData):
                completion(.success(imageData))
            case .failure:
                self?.loadFromRemote(url: url, completion: completion)
            }
        }
    }

    private func loadFromRemote(url: URL, completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success((imageData, _)):
                completion(.success(imageData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
