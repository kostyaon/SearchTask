//
//  APIEndpoints.swift
//  BB-task
//
//  Created by KonstanTanos on 23/05/2023.
//

import Foundation

struct APIEndpoints {
    
    static func getCities() -> Endpoint<CityResponse> {
        return Endpoint(path: "",
                        method: .get,
                        queryParameters: [:])
    }
}
