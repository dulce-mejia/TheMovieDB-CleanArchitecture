//
//  ReviewsEndpoint.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 29/06/22.
//

import Foundation

public struct ReviewsEndpoint: Endpoint {
    public var path: String {
        "/3/movie/\(movieId)/reviews"
    }

    let movieId: Int

    public init(movieId: Int) {
        self.movieId = movieId
    }
}
