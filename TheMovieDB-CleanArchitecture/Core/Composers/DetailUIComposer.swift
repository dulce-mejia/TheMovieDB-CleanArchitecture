//
//  DetailUIComposer.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 28/06/22.
//

import Foundation

final class DetailUIComposer {
    public static func detailComposedWith(movieViewModel: MovieViewModel,
                                          castLoader: CastLoader,
                                          similarLoader: SimilarLoader,
                                          recommendedLoader: RecommendedLoader,
                                          imageLoader: ImageLoader) -> DetailViewController {

        let viewModel = DetailViewModel(viewModel: movieViewModel,
                                        castLoader: castLoader,
                                        similarLoader: similarLoader,
                                        recommendedLoader: recommendedLoader,
                                        imageLoader: imageLoader)
        let detailVC = DetailViewController(viewModel: viewModel)
        return detailVC
    }
}
