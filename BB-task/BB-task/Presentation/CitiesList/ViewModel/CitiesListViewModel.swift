//
//  CitiesListViewModel.swift
//  BB-task
//
//  Created by KonstanTanos on 25/05/2023.
//

import Foundation

struct CitiesListViewModelActions {
    
    let showCityOnMap: (Coordinate) -> Void
}

protocol CitiesListViewModelInput {
    
    func viewDidLoad()
    func didSelectItem(at index: Int)
}

protocol CitiesListViewModelOutput {
    
    var items: Observable<[CitiesListItemViewModel]> { get }
    var loading: Observable<Bool> { get }
    var error: Observable<String> { get }
    var errorTitle: String { get }
    var controllerTitle: String { get }
}

typealias CitiesListViewModel = CitiesListViewModelInput & CitiesListViewModelOutput

final class DefaultCitiesListViewModel: CitiesListViewModel {
    
    private let networkService: NetworkService
    private let actions: CitiesListViewModelActions?
    
    // MARK: - Output
    let items: Observable<[CitiesListItemViewModel]> = Observable([])
    let loading: Observable<Bool> = Observable(false)
    let error: Observable<String> = Observable("")
    let errorTitle = "Oops, error!"
    let controllerTitle = "Cities"
    
    // Init
    init(networkService: NetworkService, actions: CitiesListViewModelActions? = nil) {
        self.networkService = networkService
        self.actions = actions
    }
}

// MARK: - Input
extension DefaultCitiesListViewModel {
    
    func viewDidLoad() {
        fetchCities(loading: true)
    }
    
    func didSelectItem(at index: Int) {
        actions?.showCityOnMap(items.value[index].coordinates)
    }
}

// MARK: - Private method's
private
extension DefaultCitiesListViewModel {
    
    func fetchCities(loading: Bool) {
        self.loading.value = loading
        networkService.request(with: APIEndpoints.getCities()) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(var cities):
                let sortingService = DutchFlagSorting<CityResponse>()
                sortingService.sortAscending(&cities)
                self.items.value = cities.map(CitiesListItemViewModel.init)
            case .failure(let error):
                self.handleError(error: error)
            }
            self.loading.value = false
        }
    }
    
    func handleError(error: Error) {
        if let error = (error as? NetworkError) {
            switch error {
            case .notConnected:
                self.error.value = "Check your Internet connection"
            default:
                self.error.value = "Failed loading cities"
            }
        }
    }
}
