//
//  SearchViewController.swift
//  BB-task
//
//  Created by KonstanTanos on 24/05/2023.
//

import Foundation
import UIKit

final class SearchViewController: UIViewController, Instantiatiable, Alertable {
    
    // MARK: - Outlets
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var citiesListContainer: UIView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var loadingStackView: UIStackView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var searchBarActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var loadingButton: UIButton!
    
    // MARK: - Actions
    @IBAction private func tryAgainTapped() {
        viewModel.didTryAgainTapped()
    }
    
    // MARK: - Properties
    private var citiesTableViewController: CitiesListTableViewController?
    private var viewModel: CitiesListViewModel!
    private var searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Lifecycle method's
    static func create(with viewModel: CitiesListViewModel) -> SearchViewController {
        let viewController = SearchViewController.instantiateViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bind(to: viewModel)
        setupSearchController()
        self.viewModel.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: CitiesListTableViewController.self),
            let destinationVC = segue.destination as? CitiesListTableViewController {
            citiesTableViewController = destinationVC
            citiesTableViewController?.viewModel = viewModel
        }
    }
}

// MARK: - Private
private
extension SearchViewController {
    
    func setupViews() {
        self.title = viewModel.controllerTitle
        activityIndicator.hidesWhenStopped = true
        searchBarActivityIndicator.hidesWhenStopped = true
    }
    
    func bind(to viewModel: CitiesListViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in
            guard let self else { return }
            self.updateItems()
        }
        viewModel.error.observe(on: self) { [weak self] error in
            guard let self else { return }
            self.showError(error)
        }
        viewModel.loading.observe(on: self) { [weak self] isLoad in 
            guard let self else { return }
            switch isLoad {
            case .fail:
                self.failLoading()
            case .done:
                self.successLoading()
            case .loading:
                self.loadingInProgress()
            }
        }
        viewModel.searchBarPlaceholder.observe(on: self) { [weak self] placeholderText in
            guard let self else { return }
            self.searchBar.placeholder = placeholderText
        }
        viewModel.searchLoading.observe(on: self) { [weak self] isLoad in
            guard let self else { return }
            switch isLoad {
            case .loading:
                self.searchBarActivityIndicator.startAnimating()
            case .done, .fail:
                self.searchBarActivityIndicator.stopAnimating()
                self.citiesTableViewController?.scrollToTheTop()
            }
        }
    }
    
    func updateItems() {
        citiesTableViewController?.reload()
    }
    
    func loadingInProgress() {
        activityIndicator.startAnimating()
        loadingButton.isHidden = true
    }
    
    func successLoading() {
        activityIndicator.stopAnimating()
        searchBar.isUserInteractionEnabled = true
    }
    
    func failLoading() {
        activityIndicator.stopAnimating()
        searchBar.isUserInteractionEnabled = false
    }
    
    func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
        
        loadingButton.isHidden = false
    }
}

// MARK: - SearchController
private
extension SearchViewController {
    
    func setupSearchController() {
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchBar.delegate = self
    }
}

extension SearchViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            viewModel.showSortableList()
            return
        }
        viewModel.didSearch(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
