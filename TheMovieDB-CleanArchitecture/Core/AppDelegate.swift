//
//  AppDelegate.swift
//  TheMovieDB-CleanArchitecture
//
//  Created by Dulce Mejia Aguayo on 21/06/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let appName = "TheMovieDB"
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        return true
    }

    private func setupRootViewController(_ rootViewController: UIViewController) {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
    }
    
    private func urlSessionConfiguration() -> URLSessionConfiguration {
        URLSessionConfiguration.default
    }
}
