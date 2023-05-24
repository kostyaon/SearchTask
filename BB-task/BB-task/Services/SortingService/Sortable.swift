//
//  Sortable.swift
//  BB-task
//
//  Created by KonstanTanos on 24/05/2023.
//

import Foundation

protocol Sortable {
    
    associatedtype T: Comparable
    
    func sortAscending(_ array: inout [T])
}
