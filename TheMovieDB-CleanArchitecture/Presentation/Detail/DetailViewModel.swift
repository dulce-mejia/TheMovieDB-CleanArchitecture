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
    public let movieViewModel: MovieViewModel
    private let castLoader: CastLoader
    private let similarLoader: SimilarLoader
    private let recommendedLoader: RecommendedLoader
    private let imageLoader: ImageLoader

    private var cast: [Cast] = []
    private var similar: [Movie] = []
    private var recommended: [Movie] = []

    public let castObserver = BehaviorRelay<[CastViewModel]>(value: [])
    public let recommendedSimilarObserver = BehaviorRelay<[MovieViewModel]>(value: [])
    public let poster = BehaviorSubject<Data?>(value: nil)

    public enum SuggestionType: Int {
        case similar = 0, recommended
    }

    public init(viewModel: MovieViewModel,
                castLoader: CastLoader,
                similarLoader: SimilarLoader,
                recommendedLoader: RecommendedLoader,
                imageLoader: ImageLoader) {
        self.movieViewModel = viewModel
        self.castLoader = castLoader
        self.similarLoader = similarLoader
        self.recommendedLoader = recommendedLoader
        self.imageLoader = imageLoader
    }

    public var title: String? {
        movieViewModel.title
    }

    public var overview: String? {
        movieViewModel.overview
    }

    public func loadMovieDetail() {
        loadPoster()
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
            self.castObserver.accept(self.map())
            self.recommendedSimilarObserver.accept(self.map(self.similar))
        }
    }

    public func toggleSimilarRecommended(by selection: SuggestionType) {
        switch selection {
        case .similar:
            self.recommendedSimilarObserver.accept(map(similar))
        case .recommended:
            self.recommendedSimilarObserver.accept(map(recommended))
        }
    }

    private func loadPoster() {
        movieViewModel.onImageReceived = { [weak self] imageData in
            self?.poster.onNext(imageData)
        }
        movieViewModel.viewWillDisplay(with: .w500)
    }

    private func getCast(completion: @escaping () -> Void) {
        castLoader.load(movieId: movieViewModel.id) { [weak self] result in
            guard let cast = try? result.get() else {
                completion()
                return
            }
            self?.cast = cast
            completion()
        }
    }

    private func getSimilar(completion: @escaping () -> Void) {
        similarLoader.load(movieId: movieViewModel.id) { result in
            guard let similar = try? result.get() else {
                completion()
                return
            }
            self.similar = similar.results
            completion()
        }
    }

    private func getRecommended(completion: @escaping () -> Void) {
        recommendedLoader.load(movieId: movieViewModel.id) { result in
            guard let recommended = try? result.get() else {
                completion()
                return
            }
            self.recommended = recommended.results
            completion()
        }
    }

    private func map() -> [CastViewModel] {
        cast.map { CastViewModel(cast: $0, imageLoader: imageLoader) }
    }

    private func map(_ list: [Movie]) -> [MovieViewModel] {
        list.map { MovieViewModel(movie: $0, imageLoader: imageLoader) }
    }
}
