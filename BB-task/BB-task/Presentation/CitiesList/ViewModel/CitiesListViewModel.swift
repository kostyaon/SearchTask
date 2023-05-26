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

enum CitiesListLoading {
    
    case loading
    case done
    case fail
}

protocol CitiesListViewModelInput {
    
    func viewDidLoad()
    func didSelectItem(at index: Int)
    func didSearch(query: String)
    func didTryAgainTapped()
}

protocol CitiesListViewModelOutput {
    
    var items: Observable<[CitiesListItemViewModel]> { get }
    var loading: Observable<CitiesListLoading> { get }
    var error: Observable<String> { get }
    var searchBarPlaceholder: Observable<String> { get }
    var errorTitle: String { get }
    var controllerTitle: String { get }
}

typealias CitiesListViewModel = CitiesListViewModelInput & CitiesListViewModelOutput

final class DefaultCitiesListViewModel<Sort: Sortable, Search: Searchable>: CitiesListViewModel where Sort.T == CityResponse {
    
    private let networkService: NetworkService
    private let sortingService: Sort
    private var searchingService: Search
    private let actions: CitiesListViewModelActions?
    
    private var citiesDictionary = Dictionary<Int, CityResponse>()
    
    // MARK: - Output
    let items: Observable<[CitiesListItemViewModel]> = Observable([])
    let loading: Observable<CitiesListLoading> = Observable(CitiesListLoading.fail)
    let error: Observable<String> = Observable("")
    let errorTitle = "Oops, error!"
    let controllerTitle = "Cities"
    var searchBarPlaceholder: Observable<String> = Observable("There is nothing to search")
    
    // Init
    init(networkService: NetworkService, sortingService: Sort, searchingService: Search, actions: CitiesListViewModelActions? = nil) {
        self.networkService = networkService
        self.sortingService = sortingService
        self.searchingService = searchingService
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
    
    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        let citiesIds = searchForCitiesIds(prefix: query)
        updateItems(with: citiesIds)
    }
    
    func didTryAgainTapped() {
        fetchCities(loading: true)
    }
}

// MARK: - Private method's
private
extension DefaultCitiesListViewModel {
    
    func searchForCitiesIds(prefix: String) -> [Int] {
        var searchDictionary: [Int: String] = [:]
        if citiesDictionary.isEmpty {
            items.value.forEach {
                citiesDictionary[$0.id] = CityResponse(country: $0.country, name: $0.name, id: $0.id, coordinates: $0.coordinates)
                searchDictionary[$0.id] = $0.name
            }
        }
        return searchingService.searchFor(prefix: prefix, in: searchDictionary)
    }
    
    func updateItems(with ids: [Int]) {
        var updatingItems: [CitiesListItemViewModel] = []
        for id in ids {
            if let city = citiesDictionary[id] {
                updatingItems.append(CitiesListItemViewModel.init(city: city))
            }
        }
        self.items.value = updatingItems
    }
    
    func fetchCities(loading: Bool) {
        self.loading.value = .loading
        networkService.request(with: APIEndpoints.getCities()) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(var cities):
                self.sortingService.sortAscending(&cities)
                self.items.value = cities.map(CitiesListItemViewModel.init)
                self.citiesDictionary = [:]
                self.searchBarPlaceholder.value = "Search city"
                self.loading.value = .done
            case .failure(let error):
                self.handleError(error: error)
                self.searchBarPlaceholder.value = "There is nothing to search"
                self.loading.value = .fail
            }
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
