//
//  ReviewsViewModel.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 29/06/22.
//

import Combine
import os
import Foundation

final class ReviewViewModel: ObservableObject {
    private let reviewsLoader: ReviewsLoader
    private let movie: Movie
    @Published var reviews: [Review] = []
    @Published var showNoContentMsg: Bool = false

    public var title: String {
        movie.title ?? ""
    }

    init(reviewsLoader: ReviewsLoader, movie: Movie) {
        self.movie = movie
        self.reviewsLoader = reviewsLoader
    }

    private func loadReviews() {
        reviewsLoader.load(movieId: movie.id) { [weak self] result in
            guard let reviews = try? result.get() else {
                // TODO: add logs 
                // os_log("Error: %@", log: .apiError, type: .error, error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self?.reviews = reviews.results
                self?.showNoContentMsg = reviews.results.isEmpty
            }
        }
    }
}
