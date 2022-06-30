//
//  FeedViewModel.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 23/06/22.
//

import Foundation
import RxSwift
import RxRelay

final class FeedViewModel {

    enum Strings: String {
        case title = "FEED_TITLE"

        var localized: String {
            NSLocalizedString(self.rawValue, comment: "")
        }
    }

    public let title = Strings.title.localized

    private let feedLoader: FeedLoader
    private let imageLoader: ImageLoader

    var movies: [MovieViewModel] = []

    init(feedLoader: FeedLoader,
         imageLoader: ImageLoader) {
        self.feedLoader = feedLoader
        self.imageLoader = imageLoader
    }

    public let listOfMovies = BehaviorRelay<[MovieViewModel]>(value: [])
    private var sectionsAndMovies = BehaviorRelay<[FeedSectionViewModel]>(value: [])

    public func loadFeed() {
        let group = DispatchGroup()
        var movies: [FeedSectionViewModel] = []
        FeedType.allCases.forEach { type in
            group.enter()
            feedLoader.load(type) { result in
                guard let feedForSection = try? result.get() else {
                    group.leave()
                    return
                }

                movies.append(FeedSectionViewModel(id: type.rawValue,
                                                   movies: feedForSection.results))
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            movies.sort { $0.id > $1.id }
            guard let self = self else { return }
            self.sectionsAndMovies.accept(movies)

            let viewModels = self.sectionsAndMovies.value
                .flatMap({ $0.movies.map {
                        MovieViewModel(movie: $0, imageLoader: self.imageLoader)
                    }
                })
            self.listOfMovies.accept(viewModels)
        }
    }

    func getSectionsCount() -> Int {
        sectionsAndMovies.value.count
    }

    func getMoviesBySection(section: Int) -> [Movie] {
        let section = sectionsAndMovies.value.first { $0.id == section }
        return section?.movies ?? []
    }

    func getMovieViewModel(by indexPath: IndexPath) -> MovieViewModel {
        listOfMovies.value[indexPath.row]
    }

    func getMoviesCountBySection(section: Int) -> Int {
        sectionsAndMovies.value.first { $0.id == section}?.movies.count ?? 0
    }
}
