//
//  AppContainer.swift
//  BB-task
//
//  Created by KonstanTanos on 27/05/2023.
//

import Foundation

final class AppContainer {
    
    // MARK: - Network
    lazy var networkService: NetworkService = {
        let configuration = DataNetworkConfiguration(
            baseURL: URL(string: AppConfiguration.APIBaseURL) ?? URL(fileURLWithPath: ""),
            headers: [
                "Authorization": "Token \(AppConfiguration.APIKey)"
            ])
        
        let service = NetworkService(config: configuration)
        return service
    }()
    
    // MARK: - SortService
    lazy var sortService: AnySortable<CityResponse> = {
        let service = DutchFlagSorting<CityResponse>()
        let typeErasedService = AnySortable(service)
        return typeErasedService
    }()
    
    // MARK: - SearchService
    lazy var searchService: TriePrefixSearching = {
        let service = TriePrefixSearching()
        return service
    }()
    
    // MARK: - Scene containers
    func makeSearchSceneContainer() -> SearchSceneContainer {
        let dependencies = SearchSceneContainer.Dependencies(
            networkService: networkService,
            sortService: sortService,
            searchService: searchService
        )
        return SearchSceneContainer(dependencies: dependencies
        )
    }
}
