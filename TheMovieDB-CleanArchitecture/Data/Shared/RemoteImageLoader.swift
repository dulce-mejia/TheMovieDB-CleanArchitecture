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
    private let base = "https://image.tmdb.org/t/p/"

    public init(client: HTTPClient, cache: ImageCache) {
        self.client = client
        self.cache = cache
    }

    public func load(url: URL, with size: PosterSizes = .w185, completion: @escaping (Result) -> Void) {
        let finalUrl = URL(string: base + size.rawValue + url.path)!

        cache.load(url: finalUrl) { [weak self] result in
            switch result {
            case let .success(imageData):
                completion(.success(imageData))
            case .failure:
                self?.loadFromRemote(url: finalUrl, completion: completion)
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
