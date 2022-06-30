//
//  ReviewsMapper.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 29/06/22.
//

import Foundation

final class ReviewsMapper {

    struct ReviewDTO: Codable {
        let id: String
        let author: String
        let authorDetails: AuthorDTO
        let content: String?

        var review: Review {
            Review(id: id, author: author, authorDetails: authorDetails.authorDetails, content: content)
        }
    }

    struct AuthorDTO: Codable {
        let username: String
        let rating: Double?

        var authorDetails: Author {
            Author(username: username, rating: rating)
        }
    }

    static func map(_ data: Data, _ response: HTTPURLResponse) -> RemoteReviewsLoader.Result {

        guard response.isOK else {
            return .failure(RemoteReviewsLoader.Error.invalidData)
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(GenericResultDTO<ReviewDTO>.self, from: data)
            let reviews = GenericResult(page: result.page, results: result.results.map({ $0.review }))
            return .success(reviews)
        } catch {
            return .failure(RemoteReviewsLoader.Error.invalidData)
        }
    }
}
