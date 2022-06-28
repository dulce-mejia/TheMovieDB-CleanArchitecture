//
//  DetailUIComposer.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 28/06/22.
//

import Foundation

final class DetailUIComposer {
    public static func detailComposedWith(movie: Movie,
                                          castLoader: CastLoader,
                                          similarLoader: SimilarLoader,
                                          recommendedLoader: RecommendedLoader,
                                          imageLoader: ImageLoader) -> DetailViewController {
        
        let viewModel = DetailViewModel(movie: movie,
                                        castLoader: castLoader,
                                        similarLoader: similarLoader,
                                        recommendedLoader: recommendedLoader,
                                        imageLoader: imageLoader)
        return DetailViewController(viewModel: viewModel)
    }
}
