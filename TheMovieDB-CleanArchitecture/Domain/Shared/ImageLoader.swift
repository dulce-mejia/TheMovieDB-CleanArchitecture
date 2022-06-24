//
//  ImageLoader.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 24/06/22.
//

import Foundation

public protocol ImageLoader {
    typealias Result = Swift.Result<Data, Error>

    func load(url: URL, completion: @escaping (Result) -> Void)
}
