//
//  CitiesListItemViewModel.swift
//  BB-task
//
//  Created by KonstanTanos on 25/05/2023.
//

import Foundation

struct CitiesListItemViewModel {
    
    let name: String
    let country: String
    let coordinates: Coordinate
    
    init(city: CityResponse) {
        self.name = city.name
        self.country = city.country
        self.coordinates = city.coordinates
    }
}
