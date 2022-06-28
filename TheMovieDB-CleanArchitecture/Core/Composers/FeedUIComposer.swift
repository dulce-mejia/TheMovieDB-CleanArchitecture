//
//  FeedUIComposer.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 23/06/22.
//

import Foundation
import UIKit

final class FeedUIComposer {
    private init() {}

    public static func feedComposedWith(httpClient: HTTPClient, navController: UINavigationController) -> FeedViewController {
        let feedLoader = RemoteFeedLoader(client: httpClient)
        let imageLoader = RemoteImageLoader(client: httpClient, cache: LocalImageCache())

        let viewModel = FeedViewModel(feedLoader: feedLoader,
                                      imageLoader: imageLoader)
        let feedVC = FeedViewController(viewModel: viewModel)
        feedVC.onSelectedMovie = { movieVM in
            let remoteCastLoader = RemoteCastLoader(client: httpClient)
            let remoteSimilarLoader = RemoteSimilarLoader(client: httpClient)
            let remoteRecommendedLoader = RemoteRecommendedLoader(client: httpClient)

            let detailViewModel = DetailViewModel(viewModel: movieVM,
                                                  castLoader: remoteCastLoader,
                                                  similarLoader: remoteSimilarLoader,
                                                  recommendedLoader: remoteRecommendedLoader,
                                                  imageLoader: imageLoader)
            let detailVC = DetailViewController(viewModel: detailViewModel)
            navController.pushViewController(detailVC, animated: true)
        }
        return feedVC
    }
}
