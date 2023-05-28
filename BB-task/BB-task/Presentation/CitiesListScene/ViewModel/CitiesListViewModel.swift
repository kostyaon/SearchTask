//
//  CitiesListViewModel.swift
//  BB-task
//
//  Created by KonstanTanos on 25/05/2023.
//

import Foundation

struct CitiesListViewModelActions {
    
    let showCityOnMap: (CitiesListItemViewModel) -> Void
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
    func showSortableList()
    func didTryAgainTapped()
}

protocol CitiesListViewModelOutput {
    
    var items: Observable<[CitiesListItemViewModel]> { get }
    var loading: Observable<CitiesListLoading> { get }
    var searchLoading: Observable<CitiesListLoading> { get }
    var error: Observable<String> { get }
    var searchBarPlaceholder: Observable<String> { get }
    var errorTitle: String { get }
    var controllerTitle: String { get }
}

typealias CitiesListViewModel = CitiesListViewModelInput & CitiesListViewModelOutput

final class DefaultCitiesListViewModel: CitiesListViewModel {
    
    private let networkService: NetworkService
    private let sortingService: AnySortable<CityResponse>
    private var searchingService: Searchable
    private let actions: CitiesListViewModelActions?
    
    private var sortableListViewModel: [CitiesListItemViewModel] = []
    private var citiesDictionary = Dictionary<Int, CityResponse>()
    
    
    private let utilityQueue = DispatchQueue(label: "com.bb-task.utility", qos: .utility)
    
    private var isTrieCreated: Bool = false
    private var isSearch: Bool = false
    private var currentQuery: String = ""
    
    private var currentOperation: SearchOperation?
    
    // MARK: - Output
    let items: Observable<[CitiesListItemViewModel]> = Observable([])
    let loading: Observable<CitiesListLoading> = Observable(CitiesListLoading.fail)
    var searchLoading: Observable<CitiesListLoading> = Observable(CitiesListLoading.fail)
    let error: Observable<String> = Observable("")
    let errorTitle = "Oops, error!"
    let controllerTitle = "Cities"
    var searchBarPlaceholder: Observable<String> = Observable("There is nothing to search")
    
    // Init
    init(networkService: NetworkService, sortingService: AnySortable<CityResponse>, searchingService: Searchable, actions: CitiesListViewModelActions? = nil) {
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
        actions?.showCityOnMap(items.value[index])
    }
    
    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        self.currentQuery = query
        self.searchLoading.value = .loading
        
        if !isTrieCreated {
            isTrieCreated = true
            utilityQueue.async {
                self.createTrie()
            }
        }
        
        if isSearch {
            utilityQueue.async {
                self.performSearch()
            }
        }
    }
    
    func didTryAgainTapped() {
        fetchCities(loading: true)
    }
    
    func showSortableList() {
        self.currentQuery = ""
        DispatchQueue.main.async {
            self.items.value = self.sortableListViewModel
            self.searchLoading.value = .done
        }
    }
}

// MARK: - Private method's
private
extension DefaultCitiesListViewModel {
    
    func performSearch() {
        self.createSearchTask(completion: nil)
    }
    
    func createSearchTask(completion: (() -> ())?) {
        let searchOperation = SearchOperation(searchString: currentQuery, searchService: self.searchingService)
        let completionBlock = {
            DispatchQueue.main.async {
                self.updateItems(with: searchOperation.searchedIDs)
            }
            completion?()
        }
        searchOperation.completionBlock = completionBlock
        self.currentOperation = searchOperation
        self.currentOperation?.start()
    }
    
    func createTrie() {
        if let service = self.searchingService as? TriePrefixSearching {
            service.createTrie(from: self.createSearchDictionary()) { [weak self] in
                // The tree has been created
                guard let self else { return }
                self.createSearchTask() {
                    self.isSearch = true
                }
            }
        }
    }
    
    func createSearchDictionary() -> [Int: String] {
        var searchDictionary: [Int: String] = [:]
        if citiesDictionary.isEmpty {
            items.value.forEach {
                citiesDictionary[$0.id] = CityResponse(country: $0.country, name: $0.name, id: $0.id, coordinates: $0.coordinates)
                searchDictionary[$0.id] = $0.name
            }
        }
        return searchDictionary
    }
    
    func updateItems(with ids: [Int]) {
        if currentQuery.isEmpty {
            showSortableList()
            return
        }
        
        var updatingItems: [CitiesListItemViewModel] = []
        for id in ids {
            if let city = citiesDictionary[id] {
                updatingItems.append(CitiesListItemViewModel.init(city: city))
            }
        }
        self.items.value = updatingItems
        self.searchLoading.value = .done
    }
    
    func fetchCities(loading: Bool) {
        self.loading.value = .loading
        networkService.request(with: APIEndpoints.getCities()) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(var cities):
                self.sortingService.sortAscending(&cities)
                self.sortableListViewModel = cities.map(CitiesListItemViewModel.init)
                self.items.value = self.sortableListViewModel
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
