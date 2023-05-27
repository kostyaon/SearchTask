//
//  CityMapViewController.swift
//  BB-task
//
//  Created by KonstanTanos on 27/05/2023.
//

import Foundation
import UIKit
import MapKit

final class CityMapViewController: UIViewController, Instantiatiable {
    
    // MARK: - Outlets
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var mapView: MKMapView!
    
    // MARK: - Properties
    private var viewModel: CitiesListItemViewModel!
    
    // MARK: - Lifecycle method's
    static func create(with viewModel: CitiesListItemViewModel) -> CityMapViewController {
        let viewController = CityMapViewController.instantiateViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        showCityLocation()
    }
    
}

// MARK: - Private
private
extension CityMapViewController {
    
    func setupTitle() {
        self.title = "\(viewModel.name), \(viewModel.country)"
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func setCoordinatesOn(_ location: CLLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = "\(viewModel.name), \(viewModel.country)"
        mapView.addAnnotation(annotation)
    }
    
    func showCityLocation() {
        let initialLocation = CLLocation(latitude: viewModel.coordinates.latitude, longitude: viewModel.coordinates.longitude)
        centerMapOnLocation(location: initialLocation)
        setCoordinatesOn(initialLocation)
    }
}
