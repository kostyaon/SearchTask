//
//  SearchSceneContainer.swift
//  BB-task
//
//  Created by KonstanTanos on 27/05/2023.
//

import Foundation
import UIKit

final class SearchSceneContainer: SearchFlowCoordinatorDependencies {
    
    struct Dependencies {
        
        let networkService: NetworkService
        let sortService: AnySortable<CityResponse>
        let searchService: Searchable
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - SearchListViewController
    func makeSearchListViewController(actions: CitiesListViewModelActions) -> SearchViewController {
        SearchViewController.create(with: makeSearchListViewModel(actions: actions))
    }
    
    func makeSearchListViewModel(actions: CitiesListViewModelActions) -> CitiesListViewModel {
        DefaultCitiesListViewModel(networkService: dependencies.networkService, sortingService: dependencies.sortService, searchingService: dependencies.searchService, actions: actions)
    }
    
    // MARK: - CityMapViewController
    func makeCityMapViewController(viewModel: CitiesListItemViewModel) -> CityMapViewController {
        CityMapViewController.create(with: viewModel)
    }
    
    // MARK: - Flow coordinators
    func makeSearchFlowCoordinator(navigationController: UINavigationController) -> SearchFlowCoordinator {
        SearchFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}
