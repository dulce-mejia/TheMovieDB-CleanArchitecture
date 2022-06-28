//
//  MovieViewModel.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 23/06/22.
//

import Foundation

public final class MovieViewModel {

    private let movie: Movie
    private let imageLoader: ImageLoader
    public var onImageReceived: ((Data) -> Void)?

    init(movie: Movie,
         imageLoader: ImageLoader) {
        self.movie = movie
        self.imageLoader = imageLoader
    }

    public var id: Int {
        movie.id
    }

    public var title: String {
        movie.title ?? ""
    }

    public var overview: String {
        movie.overview ?? ""
    }

    private var posterUrl: URL? {
        guard let path = movie.posterPath,
              let url = URL(string: path) else {
            return nil
        }
        return url
    }

    public func viewWillDisplay() {
        guard let url = posterUrl else { return }
        imageLoader.load(url: url, with: .w185) { [weak self] result in
            guard let imageData = try? result.get() else {
                return
            }
            self?.onImageReceived?(imageData)
        }
    }
}
