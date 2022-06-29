//
//  RemoteReviewsLoader.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 29/06/22.
//

import Foundation

public final class RemoteReviewsLoader: ReviewsLoader {

    public typealias Result = ReviewsLoader.Result

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
        let endpoint = ReviewsEndpoint(movieId: movieId)

        guard let finalUrl = endpoint.urlComponents?.url else { return }

        client.get(from: finalUrl) { result in
            switch result {
            case let .success((data, response)):
                let reviews = ReviewsMapper.map(data, response)
                completion(reviews)
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
