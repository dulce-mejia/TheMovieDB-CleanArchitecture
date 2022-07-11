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
    private let movieViewModel: MovieViewModel
    @Published var reviews: [Review] = []
    @Published var showNoContentMsg: Bool = false

    enum Strings: String {
        case alertOk = "ALERT_OK"
        case alertTitle = "ALERT_TITLE"
        case alertMsg = "ALERT_MESSAGE"

        var localized: String {
            NSLocalizedString(self.rawValue, comment: "")
        }
    }

    init(reviewsLoader: ReviewsLoader, movieViewModel: MovieViewModel) {
        self.movieViewModel = movieViewModel
        self.reviewsLoader = reviewsLoader
    }

    public var title: String {
        movieViewModel.title
    }

    public var alertOk: String {
        Strings.alertOk.localized
    }

    public var alertTitle: String {
        Strings.alertTitle.localized
    }

    public var alertMsg: String {
        Strings.alertMsg.localized
    }

    public func loadReviews() {
        reviewsLoader.load(movieId: movieViewModel.id) { [weak self] result in
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