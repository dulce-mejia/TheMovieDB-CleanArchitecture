//
//  FeedType.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 22/06/22.
//

import Foundation

public enum FeedType: Int, CaseIterable, Endpoint {

    case nowPlaying
    case trending
    case popular
    case topRated
    case upcoming

    public var path: String {
        switch self {
        case .nowPlaying:
            return "/3/movie/now_playing"
        case .trending:
            return "/3/trending/movie/day"
        case .popular:
            return "/3/movie/popular"
        case .topRated:
            return "/3/movie/top_rated"
        case .upcoming:
            return "/3/movie/upcoming"
        }
    }
}
