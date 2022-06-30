//
//  RecommendedEndpoint.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 27/06/22.
//

import Foundation

public struct RecommendedEnpoint: Endpoint {
    public var path: String {
        "/3/movie/\(movieId)/recommendations"
    }

    let movieId: Int

    public init(movieId: Int) {
        self.movieId = movieId
    }
}
