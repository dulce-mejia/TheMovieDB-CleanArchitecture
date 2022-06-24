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

    public let title = "The Movie DB"

    private let feedLoader: FeedLoader

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    let sectionsAndMovies = BehaviorRelay<[FeedSectionViewModel]>(value: [])

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
            self?.sectionsAndMovies.accept(movies)
        }
    }

    func getSectionsCount() -> Int {
        sectionsAndMovies.value.count
    }

    func getMoviesBySection(section: Int) -> [Movie] {
        let section = sectionsAndMovies.value.first { $0.id == section }
        return section?.movies ?? []
    }

    func getMoviesCountBySection(section: Int) -> Int {
        sectionsAndMovies.value.first { $0.id == section}?.movies.count ?? 0
    }
}
