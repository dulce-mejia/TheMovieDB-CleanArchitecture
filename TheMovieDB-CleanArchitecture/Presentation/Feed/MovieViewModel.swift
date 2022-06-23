//
//  MovieViewModel.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 23/06/22.
//

import Foundation

final class MovieViewModel {

    let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    public var title: String {
        movie.title ?? ""
    }
    
    public var posterUrl: URL? {
        guard let path = movie.posterPath,
              let url = URL(string: path) else {
            return nil
        }
        return url
    }
}
