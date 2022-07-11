//
//  FeedUIComposer.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 23/06/22.
//

import Foundation
import UIKit
import SwiftUI

final class FeedUIComposer {
    private init() {}

    public static func feedComposedWith(httpClient: HTTPClient) -> FeedViewController {
        let feedLoader = RemoteFeedLoader(client: httpClient)
        let imageLoader = RemoteImageLoader(client: httpClient, cache: LocalImageCache())

        let viewModel = FeedViewModel(feedLoader: feedLoader,
                                      imageLoader: imageLoader)
        let feedVC = FeedViewController(viewModel: viewModel)
        return feedVC
    }
}
