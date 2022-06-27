//
//  RecommendedLoader.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 27/06/22.
//

import Foundation

public protocol RecommendedLoader {
    typealias Result = Swift.Result<GenericResult<Movie>?, Error>

    func load(movieId: Int, completion: @escaping (Result) -> Void)
}
