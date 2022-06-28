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

    private var imageUrl: URL? {
        guard let path = cast.profilePath,
              let url = URL(string: path) else {
            return nil
        }
        return url
    }

    public func viewWillDisplay() {
        guard let url = imageUrl else { return }
        imageLoader.load(url: url, with: .w154) { result in
            guard let imageData = try? result.get() else {
                return
            }
            onImageReceived?(imageData)
        }
    }
}
