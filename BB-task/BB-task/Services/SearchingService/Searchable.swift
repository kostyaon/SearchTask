//
//  Searchable.swift
//  BB-task
//
//  Created by KonstanTanos on 24/05/2023.
//

import Foundation

protocol Searchable {
    
    mutating func searchFor(prefix: String, in dictionary: Dictionary<Int, String>) -> [Int]
}
