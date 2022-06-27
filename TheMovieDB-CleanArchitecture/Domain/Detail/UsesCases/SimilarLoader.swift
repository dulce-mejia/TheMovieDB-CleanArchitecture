//
//  SimilarLoader.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 27/06/22.
//

import Foundation

public protocol SimilarLoader {
    typealias Result = Swift.Result<[Movie], Error>

    func load(movieId: Int, completion: @escaping (Result) -> Void)
}
