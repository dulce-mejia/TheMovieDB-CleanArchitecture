//
//  UINavigationAppearance+defaultApperance.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 21/06/22.
//

import Foundation
import UIKit

extension UINavigationBarAppearance {
    static func setDefaultApperance() {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithTransparentBackground()
        standardAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemPurple]

        UINavigationBar.appearance().standardAppearance = standardAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = standardAppearance
        UINavigationBar.appearance().compactAppearance = standardAppearance
        if #available(iOS 15.0, *) { // For compatibility with earlier iOS.
            UINavigationBar.appearance().compactScrollEdgeAppearance = standardAppearance
        }
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().tintColor = .systemPurple
    }
}
