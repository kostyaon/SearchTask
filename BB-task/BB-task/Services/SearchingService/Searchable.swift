//
//  Searchable.swift
//  BB-task
//
//  Created by KonstanTanos on 24/05/2023.
//

import Foundation

protocol Searchable {
    
    associatedtype T: Collection
    
    func searchFor(prefix: T) -> [Int]
}
