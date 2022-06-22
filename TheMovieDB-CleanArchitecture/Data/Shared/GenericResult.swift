//
//  GenericResult.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 22/06/22.
//

import Foundation

public struct GenericResult<T> {
    let page: Int
    var results: [T]
}
