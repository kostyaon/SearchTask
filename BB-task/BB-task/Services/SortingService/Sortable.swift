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

struct AnySortable<T: Comparable>: Sortable {
    
    private let _sortAscending: (_ array: inout [T]) -> ()
    
    init<S: Sortable>(_ sortable: S) where S.T == T {
        self._sortAscending = sortable.sortAscending
    }
    
    func sortAscending(_ array: inout [T]) {
        _sortAscending(&array)
    }
}
