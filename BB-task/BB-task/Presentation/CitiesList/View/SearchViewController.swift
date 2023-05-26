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
    
    // MARK: - Properties
    private var citiesTableViewController: CitiesListTableViewController?
    private var viewModel: CitiesListViewModel!
    
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
    }
    
    func updateItems() {
        citiesTableViewController?.reload()
    }
    
    func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }
}
