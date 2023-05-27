//
//  CitiesListTableViewController.swift
//  BB-task
//
//  Created by KonstanTanos on 25/05/2023.
//

import Foundation
import UIKit

final class CitiesListTableViewController: UITableViewController {
    
    var viewModel: CitiesListViewModel!
    var loadingIndicator: UIActivityIndicatorView?
    
    // MARK: - Lifecycle method's
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func scrollToTheTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        if viewModel.items.value.count != 0 {
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}

// MARK: - Private
private
extension CitiesListTableViewController {
    
    func setupViews() {
        self.tableView.register(CityListItemCell.getNib(), forCellReuseIdentifier: CityListItemCell.reuseIdentifier)
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CitiesListTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityListItemCell.reuseIdentifier, for: indexPath) as? CityListItemCell else {
            assertionFailure("Faile to dequeue \(CityListItemCell.self) cell with identifier \(CityListItemCell.reuseIdentifier)")
            return UITableViewCell()
        }
        
        cell.setupCell(with: viewModel.items.value[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
