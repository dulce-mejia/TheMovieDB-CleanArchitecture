//
//  MainCoordinator.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 01/07/22.
//

import UIKit
import SwiftUI

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()

    var navigationController: UINavigationController
    var client: HTTPClient

    init(navigationController: UINavigationController, client: HTTPClient) {
        self.navigationController = navigationController
        self.client = client
    }

    func start() {
        let vc = FeedUIComposer.feedComposedWith(httpClient: client)
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }

    func showDetail(_ movieVM: MovieViewModel) {
        let remoteCastLoader = RemoteCastLoader(client: self.client)
        let remoteSimilarLoader = RemoteSimilarLoader(client: self.client)
        let remoteRecommendedLoader = RemoteRecommendedLoader(client: self.client)
        let imageLoader = RemoteImageLoader(client: self.client, cache: LocalImageCache())

        let vc = DetailUIComposer.detailComposedWith(movieViewModel: movieVM,
                                                     castLoader: remoteCastLoader,
                                                     similarLoader: remoteSimilarLoader,
                                                     recommendedLoader: remoteRecommendedLoader,
                                                     imageLoader: imageLoader)
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }

    func showReviews(_ movieVM: MovieViewModel) {
        let reviewsLoader = RemoteReviewsLoader(client: self.client)
        let reviewsVC = ReviewsUIComposer.composedWith(reviewsLoader: reviewsLoader,
                                                       movieViewModel: movieVM)
         let viewContainer = UIHostingController(rootView: reviewsVC)
        self.navigationController.pushViewController(viewContainer, animated: true)
    }
}
