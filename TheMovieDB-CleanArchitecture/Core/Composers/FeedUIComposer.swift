//
//  FeedUIComposer.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 23/06/22.
//

import Foundation

final class FeedUIComposer {
    private init() {}

    public static func feedComposedWith(feedLoader: FeedLoader) -> FeedViewController {
        let viewModel = FeedViewModel(feedLoader: feedLoader)
        return FeedViewController(viewModel: viewModel)
    }
}
