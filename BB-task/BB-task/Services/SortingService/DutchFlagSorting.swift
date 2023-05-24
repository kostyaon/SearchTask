//
//  DutchFlagSorting.swift
//  BB-task
//
//  Created by KonstanTanos on 24/05/2023.
//

import Foundation

struct DutchFlagSorting<T: Comparable>: Sortable {
    
    init() {}
    
    func sortAscending(_ array: inout [String]) {
        sortDutchFlag(&array, low: 0, high: array.count - 1)
    }
}

private
extension DutchFlagSorting {
    
    func partitionDutchFlag<T: Comparable>(_ array: inout [T], low: Int, high: Int, pivotIndex: Int) -> (Int, Int) {
        let pivot = array[pivotIndex]
        var smaller = low
        var equal = low
        var larger = high
        
        while equal <= larger {
            if array[equal] < pivot {
                array.swapAt(smaller, equal)
                smaller += 1
                equal += 1
            } else if array[equal] == pivot {
                equal += 1
            } else {
                array.swapAt(equal, larger)
                larger -= 1
            }
        }
        
        return (smaller, larger)
    }
    
    func sortDutchFlag<T: Comparable>(_ array: inout [T], low: Int, high: Int) {
         if low < high {
             let (middleFirst, middleLast) =
             partitionDutchFlag(&array, low: low, high: high, pivotIndex:
                                 high)
             sortDutchFlag(&array, low: low, high: middleFirst - 1)
             sortDutchFlag(&array, low: middleLast + 1, high: high)
         }
     }
}
