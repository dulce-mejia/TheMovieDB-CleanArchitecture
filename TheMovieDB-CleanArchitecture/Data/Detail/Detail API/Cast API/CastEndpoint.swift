//
//  CastEndpoint.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 27/06/22.
//

import Foundation

public struct CastEndpoint: Endpoint {
    public var path: String {
        "/3/movie/\(movieId)/credits"
    }

    public var queryItems: [String: String] = [:]

    let movieId: Int

    public init(movieId: Int) {
        self.movieId = movieId
    }
}
