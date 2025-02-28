//
//  AppDelegate.swift
//  NekoCuan
//
//  Created by Felicia Diana on 16/05/24.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: LaunchViewController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}


