//
//  RemoteRecommendedLoader.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 27/06/22.
//

import Foundation

public final class RemoteRecommendedLoader: RecommendedLoader {

    public typealias Result = RecommendedLoader.Result

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
        case badRequest
    }

    let client: HTTPClient

    public init(client: HTTPClient) {
        self.client = client
    }

    public func load(movieId: Int, completion: @escaping (Result) -> Void) {
        let endpoint = RecommendedEnpoint(movieId: movieId)
        guard let finalUrl = endpoint.urlComponents?.url else { return }

        client.get(from: finalUrl) { result in
            switch result {
            case let .success((data, response)):
                completion(RecommendedMapper.map(data, response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
