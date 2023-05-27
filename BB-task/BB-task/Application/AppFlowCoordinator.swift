//
//  AppFlowCoordinator.swift
//  BB-task
//
//  Created by KonstanTanos on 27/05/2023.
//

import Foundation
import UIKit

final class AppFlowCoordinator {
    
    private let appContainer: AppContainer
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, appContainer: AppContainer) {
        self.navigationController = navigationController
        self.appContainer = appContainer
    }
    
    func start() {
        let searchSceneContainer = appContainer.makeSearchSceneContainer()
        let flow = searchSceneContainer.makeSearchFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
