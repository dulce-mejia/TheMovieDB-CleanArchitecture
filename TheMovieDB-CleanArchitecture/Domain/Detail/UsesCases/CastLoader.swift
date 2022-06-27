//
//  CastLoader.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 27/06/22.
//

import Foundation

public protocol CastLoader {
    typealias Result = Swift.Result<[Cast], Error>

    func load(movieId: Int, completion: @escaping (Result) -> Void)
}
