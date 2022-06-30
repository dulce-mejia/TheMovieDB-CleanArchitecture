//
//  FeedViewModel.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 23/06/22.
//

import Foundation
import RxSwift
import RxRelay

public final class FeedViewModel {

    public enum Strings: String {
        case title = "FEED_TITLE"
        case nowPlaying = "SECTION_NOW_PLAYING"
        case trending = "SECTION_TRENDING"
        case popular = "SECTION_POPULAR"
        case topRated = "SECTION_TOP_RATED"
        case upcoming = "SECTION_UPCOMING"

        var localized: String {
            NSLocalizedString(self.rawValue, comment: "")
        }
    }

    public enum FeedSection: Int {
        case nowPlaying
        case trending
        case popular
        case topRated
        case upcoming

        var title: String {
            switch self {
            case .nowPlaying:
                return Strings.nowPlaying.localized
            case .trending:
                return Strings.trending.localized
            case .popular:
                return Strings.popular.localized
            case .topRated:
                return Strings.topRated.localized
            case .upcoming:
                return Strings.upcoming.localized
            }
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
        FeedType.allCases.forEach { [weak self] type in
            group.enter()
            feedLoader.load(type) { result in
                guard let self = self else { return }
                guard let feedForSection = try? result.get() else {
                    group.leave()
                    return
                }

                movies.append(FeedSectionViewModel(section: self.getSection(type),
                                                   movies: feedForSection.results))
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            movies.sort { $0.section.rawValue < $1.section.rawValue }
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

    private func getSection(_ section: FeedType) -> FeedSection {
        switch section {
        case .nowPlaying:
            return .nowPlaying
        case .trending:
            return .trending
        case .popular:
            return .popular
        case .topRated:
            return .topRated
        case .upcoming:
            return .upcoming
        }
    }

    func getSectionsCount() -> Int {
        sectionsAndMovies.value.count
    }

    func getFeedSection(by indexPath: IndexPath) -> FeedSection? {
        guard indexPath.section <= sectionsAndMovies.value.count else {
            return nil
        }
        let feedSection = sectionsAndMovies.value[indexPath.section]
        return feedSection.section
    }

    func getMoviesBySection(section: Int) -> [Movie] {
        let section = sectionsAndMovies.value.first { $0.section.rawValue == section }
        return section?.movies ?? []
    }

    func getMovieViewModel(by indexPath: IndexPath) -> MovieViewModel {
        listOfMovies.value[indexPath.row]
    }

    func getMoviesCountBySection(section: Int) -> Int {
        sectionsAndMovies.value.first { $0.section.rawValue == section}?.movies.count ?? 0
    }
}
