//
//  DetailViewModel.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 28/06/22.
//

import Foundation
import RxSwift
import RxCocoa
import os

public final class DetailViewModel {
    private let movie: Movie
    private let castLoader: CastLoader
    private let similarLoader: SimilarLoader
    private let recommendedLoader: RecommendedLoader
    private let imageLoader: ImageLoader

    private var cast: [Cast] = []
    private var similar: [Movie] = []
    private var recommended: [Movie] = []

    public let castObserver = BehaviorRelay<[Cast]>(value: [])
    public let recommendedSimilarObserver = BehaviorRelay<[Movie]>(value: [])

    public init(movie: Movie,
                castLoader: CastLoader,
                similarLoader: SimilarLoader,
                recommendedLoader: RecommendedLoader,
                imageLoader: ImageLoader) {
        self.movie = movie
        self.castLoader = castLoader
        self.similarLoader = similarLoader
        self.recommendedLoader = recommendedLoader
        self.imageLoader = imageLoader
    }

    public var title: String? {
        movie.title
    }

    public var overview: String? {
        movie.overview
    }

    public var movieViewModel: MovieViewModel {
        MovieViewModel(movie: movie, imageLoader: imageLoader)
    }

    public func loadMovieDetail() {
        let group = DispatchGroup()
        group.enter()
        getCast {
            group.leave()
        }
        group.enter()
        getSimilar {
            group.leave()
        }
        group.enter()
        getRecommended {
            group.leave()
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.castObserver.accept(self.cast)
            self.recommendedSimilarObserver.accept(self.similar)
        }
    }

    private func getCast(completion: @escaping () -> Void) {
        castLoader.load(movieId: movie.id) { [weak self] result in
            guard let cast = try? result.get() else {
                completion()
                return
            }
            self?.cast = cast
            completion()
        }
    }

    private func getSimilar(completion: @escaping () -> Void) {
        similarLoader.load(movieId: movie.id) { result in
            guard let similar = try? result.get() else {
                completion()
                return
            }
            self.similar = similar.results
            completion()
        }
    }

    private func getRecommended(completion: @escaping () -> Void) {
        recommendedLoader.load(movieId: movie.id) { result in
            guard let recommended = try? result.get() else {
                completion()
                return
            }
            self.recommended = recommended.results
            completion()
        }
    }
}
