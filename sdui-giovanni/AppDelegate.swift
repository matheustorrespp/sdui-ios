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
    
    private func launch() -> Bool {
        window = .init(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController: HomeViewController())
        nav.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }
}

