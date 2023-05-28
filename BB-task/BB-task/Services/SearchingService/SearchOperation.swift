//
//  SearchOperation.swift
//  BB-task
//
//  Created by KonstanTanos on 27/05/2023.
//

import Foundation

final class SearchOperation: Operation {
    
    var searchedIDs: [Int] = []
    
    // ADD PRIVATE
     let searchString: String
    private let searchService: Searchable
    
    init(searchString: String, searchService: Searchable) {
        self.searchString = searchString
        self.searchService = searchService
        super.init()
    }
    
    override func main() {
        searchedIDs = searchService.searchFor(prefix: searchString)
    }
}
