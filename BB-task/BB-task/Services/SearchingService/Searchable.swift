//
//  Searchable.swift
//  BB-task
//
//  Created by KonstanTanos on 24/05/2023.
//

import Foundation

protocol Searchable {
    
    func searchFor(prefix: String) -> [Int]
}
