//
//  FeedLoader.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 22/06/22.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<GenericResult<Movie>?, Error>

    func load(_ feedType: FeedType, completion: @escaping (FeedLoader.Result) -> Void)
}
