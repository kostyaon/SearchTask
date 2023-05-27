//
//  AppDelegate.swift
//  BB-task
//
//  Created by KonstanTanos on 23/05/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let appContainer = AppContainer()
    var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()

        window?.rootViewController = navigationController
        appFlowCoordinator = AppFlowCoordinator(navigationController: navigationController, appContainer: appContainer)
        appFlowCoordinator?.start()
        window?.makeKeyAndVisible()
    
        return true
    }
}

