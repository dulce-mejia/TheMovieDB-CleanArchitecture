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
    var coordinator: MainCoordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBarAppearance.setDefaultApperance()
        runAppFlow()
        return true
    }

    private func runAppFlow() {
        let httpClient = URLSessionHTTPClient(session: makeURLSession())
        let navController = UINavigationController()
        coordinator = MainCoordinator(navigationController: navController,
                                      client: httpClient)
        coordinator?.start()

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.overrideUserInterfaceStyle = .dark
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }

    private func makeURLSession() -> URLSession {
        URLSession(configuration: .default)
    }
}
