//
//  RemoteFeedLoader.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 22/06/22.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {

    public typealias Result = FeedLoader.Result

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
        case badRequest
    }

    let client: HTTPClient

    public init(client: HTTPClient) {
        self.client = client
    }

    public func load(_ feedType: FeedType, completion: @escaping (Result) -> Void) {

        guard let finalUrl = feedType.urlComponents?.url else { return }
        print("url....", finalUrl)
        client.get(from: finalUrl) { result in
            switch result {
            case let .success((data, response)):
                let feed = FeedMapper.map(data, response)
                completion(feed)
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
