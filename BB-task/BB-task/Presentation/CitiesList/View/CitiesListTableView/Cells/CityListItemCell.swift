//
//  CityListItemCell.swift
//  BB-task
//
//  Created by KonstanTanos on 25/05/2023.
//

import Foundation
import UIKit

final class CityListItemCell: UITableViewCell {
    
    static let reuseIdentifier = String(String(describing: CityListItemCell.self))
    
    // MARK: - Outlets
    @IBOutlet private weak var nameCountryLabel: UILabel!
    @IBOutlet private weak var longitudeLabel: UILabel!
    @IBOutlet private weak var latitudeLabel: UILabel!
    
    // MARK: - Properties
    private var viewModel: CitiesListItemViewModel
    
    // MARK: - Public method's
    func setupCell(with viewModel: CitiesListItemViewModel) {
        self.viewModel = viewModel
        
        nameCountryLabel.text = "\(viewModel.name) \(viewModel.country)"
        longitudeLabel.text = "longitude: \(viewModel.coordinates.longitude)"
        latitudeLabel.text = "latitude: \(viewModel.coordinates.latitude)"
    }
}
