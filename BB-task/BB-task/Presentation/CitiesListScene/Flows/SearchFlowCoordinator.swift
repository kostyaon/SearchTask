//
//  SearchFlowCoordinator.swift
//  BB-task
//
//  Created by KonstanTanos on 27/05/2023.
//

import Foundation
import UIKit

protocol SearchFlowCoordinatorDependencies {
    
    func makeSearchListViewController(actions: CitiesListViewModelActions) -> SearchViewController
    func makeCityMapViewController(coordinate: Coordinate) -> UIViewController
}

final class SearchFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: SearchFlowCoordinatorDependencies
    
    private weak var searchListViewController: SearchViewController?
    
    
    init(navigationController: UINavigationController, dependencies: SearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = CitiesListViewModelActions(showCityOnMap: showCityOnMap)
        
        let viewController = dependencies.makeSearchListViewController(actions: actions)
        navigationController?.pushViewController(viewController, animated: false)
        searchListViewController = viewController
    }
}

// MARK: - Private
private
extension SearchFlowCoordinator {
    
    func showCityOnMap(coordinate: Coordinate) {
        let mapViewControlelr = dependencies.makeCityMapViewController(coordinate: coordinate)
        navigationController?.pushViewController(mapViewControlelr, animated: true)
    }
}
