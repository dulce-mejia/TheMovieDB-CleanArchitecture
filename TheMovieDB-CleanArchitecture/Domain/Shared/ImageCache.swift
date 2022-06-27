//
//  ImageCache.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 24/06/22.
//

import Foundation

public protocol ImageCache {
    typealias Result = Swift.Result<Data, Error>

    func load(url: URL, completion: @escaping (Result) -> Void)
    func save(_ data: Data, for url: URL)
}
