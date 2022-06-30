//
//  Review.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 29/06/22.
//

import Foundation

public struct Review {
    public let id: String
    public let author: String
    public let authorDetails: Author
    public let content: String?
}
