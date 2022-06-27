//
//  FeedMapper.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 22/06/22.
//

import Foundation

final class FeedMapper {

    struct MovieDTO: Codable {
        let id: Int
        let backdropPath: String?
        let voteCount: Int
        let originalTitle: String
        let posterPath: String?
        let title: String?
        let voteAverage: Double
        let releaseDate: String?
        let overview: String?

        var movie: Movie {
            Movie(id: id,
                  backdropPath: backdropPath,
                  voteCount: voteCount,
                  originalTitle: originalTitle,
                  posterPath: posterPath,
                  title: title,
                  voteAverage: voteAverage,
                  releaseDate: releaseDate,
                  overview: overview)
        }
    }

    static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteFeedLoader.Result {

        guard response.isOK else {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(GenericResultDTO<MovieDTO>.self, from: data)
            return .success(GenericResult(page: result.page,
                                          results: result.results.map({ $0.movie })))
        } catch {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }
    }
}
