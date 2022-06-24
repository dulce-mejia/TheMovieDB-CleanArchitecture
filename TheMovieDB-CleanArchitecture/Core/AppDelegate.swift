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
        UINavigationBarAppearance.setDefaultApperance()
        runAppFlow()
        return true
    }

    private func runAppFlow() {
        let httpClient = URLSessionHTTPClient(session: makeURLSession())
        let firstVC = loadFirstVC(httpClient: httpClient)
        setupRootViewController(firstVC)
    }

    private func setupRootViewController(_ rootViewController: UIViewController) {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
    }

    private func loadFirstVC(httpClient: HTTPClient) -> UIViewController {
        let feedLoader = RemoteFeedLoader(client: httpClient)
        let feedVC = FeedUIComposer.feedComposedWith(feedLoader: feedLoader)
        return UINavigationController(rootViewController: feedVC)
    }

    private func makeURLSession() -> URLSession {
        URLSession(configuration: .default)
    }
}
