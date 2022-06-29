//
//  ReviewsUIComposer.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 29/06/22.
//

import Foundation

final class ReviewsUIComposer {
    public static func composedWith(reviewsLoader: ReviewsLoader,
                                    movie: Movie) -> ReviewsViewController {
        let viewModel = ReviewViewModel(reviewsLoader: reviewsLoader,
                                        movie: movie)
        return ReviewsViewController(viewModel: viewModel)
    }
}
