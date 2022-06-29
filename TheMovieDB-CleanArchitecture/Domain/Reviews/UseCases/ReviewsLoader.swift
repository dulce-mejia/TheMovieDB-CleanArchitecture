//
//  ReviewsLoader.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 29/06/22.
//

import Foundation

public protocol ReviewsLoader {
    typealias Result = Swift.Result<GenericResult<Review>?, Error>

    func load(movieId: Int, completion: @escaping (Result) -> Void)
}
