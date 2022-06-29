//
//  RemoteCastLoader.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 27/06/22.
//

import Foundation

public final class RemoteCastLoader: CastLoader {
    public typealias Result = CastLoader.Result

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
        let endpoint = CastEndpoint(movieId: movieId)
        guard let finalUrl = endpoint.urlComponents?.url else { return }

        client.get(from: finalUrl) { result in
            switch result {
            case let .success((data, response)):
                completion(CastMapper.map(data, response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
