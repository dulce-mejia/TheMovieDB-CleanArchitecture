//
//  CastViewModel.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 28/06/22.
//

import Foundation

public struct CastViewModel {
    public let cast: Cast
    public let imageLoader: ImageLoader
    public var onImageReceived: ((Data) -> Void)?
}
