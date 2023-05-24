//
//  CityResponse.swift
//  BB-task
//
//  Created by KonstanTanos on 23/05/2023.
//

import Foundation

struct Coordinate: Decodable {
    
    let longitude: Double
    let latitude: Double
    
    private
    enum CodingKeys: String, CodingKey {
        
        case longitude = "lon"
        case latitude = "lat"
    }
}

struct CityResponse: Decodable {
    
    let country: String
    let name: String
    let id: Int
    let coordinates: Coordinate
    
    private
    enum CodingKeys: String, CodingKey {
        
        case country
        case name
        case id = "_id"
        case coordinates = "coord"
    }
}
