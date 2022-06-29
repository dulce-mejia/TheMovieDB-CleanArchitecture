//
//  ReviewsUIComposer.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 29/06/22.
//

import Foundation

final class ReviewsUIComposer {
    public static func composedWith(reviewsLoader: ReviewsLoader,
                                    movieViewModel: MovieViewModel) -> ReviewsViewController {
        let viewModel = ReviewViewModel(reviewsLoader: reviewsLoader,
                                        movieViewModel: movieViewModel)
        return ReviewsViewController(viewModel: viewModel)
    }
}
