//
//  UIImageView+loadImage.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 23/06/22.
//

import Foundation
import UIKit
// TODO: PosterSizes enum put in correct group
enum PosterSizes: String {
    case w92, w154, w185, w342, w500, w780, original
}
//TODO: complete loader for images
//extension UIImageView {
//    func loadImage(with url: String?, size: PosterSizes = .w185) -> HTTPClientTask? {
//        return ImageDownloaderService.shared.getImage(with: url, completion: { [weak self] image in
//            guard let image = image else { return }
//            DispatchQueue.main.async {
//                self?.image = image
//            }
//        })
//    }
//}
