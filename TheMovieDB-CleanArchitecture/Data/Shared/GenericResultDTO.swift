//
//  GenericResultDTO.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 22/06/22.
//

import Foundation

public struct GenericResultDTO<T: Codable>: Codable {
    let page: Int
    var results: [T]
}
