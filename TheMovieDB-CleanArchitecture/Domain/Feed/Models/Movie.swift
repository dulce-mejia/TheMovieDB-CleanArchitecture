//
//  Movie.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 22/06/22.
//

import Foundation

public struct Movie {
   public let id: Int
   public let backdropPath: String?
   public let voteCount: Int
   public let originalTitle: String
   public let posterPath: String?
   public let title: String?
   public let voteAverage: Double
   public let releaseDate: String?
   public let overview: String?

    public init(id: Int,
                backdropPath: String?,
                voteCount: Int,
                originalTitle: String,
                posterPath: String?,
                title: String?,
                voteAverage: Double,
                releaseDate: String?,
                overview: String?) {
        self.id = id
        self.backdropPath = backdropPath
        self.voteCount = voteCount
        self.originalTitle = originalTitle
        self.posterPath = posterPath
        self.title = title
        self.voteAverage = voteAverage
        self.releaseDate = releaseDate
        self.overview = overview
    }
}
