//
//  AppDelegate.swift
//  sdui-giovanni
//
//  Created by Matheus Fernandes on 26/01/26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        launch()
    }

    /// Chamado quando o app recebe uma URL externa (ex: sdui://detail?title=torres)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        DeeplinkNavigator.shared.navigate(to: url.absoluteString)
        return true
    }

    private func launch() -> Bool {
        window = .init(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController: HomeViewController())
        nav.setNavigationBarHidden(true, animated: false)
        DeeplinkNavigator.shared.setup(with: nav)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }
}

